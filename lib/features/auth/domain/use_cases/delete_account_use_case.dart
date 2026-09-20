import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../settings/domain/repositories/i_settings_local_repository.dart';
import '../../../sync/domain/adapters/sync_entity_adapters.dart';
import '../../../sync/domain/repositories/i_sync_remote_repository.dart';
import '../failures/auth_failures.dart';
import '../models/e_account_deletion_scope.dart';
import '../repositories/i_auth_repository.dart';
import '../repositories/i_user_profile_local_repository.dart';
import '../repositories/i_user_profile_remote_repository.dart';

/// Permanently deletes the user's account and their data.
///
/// **Apple Guideline 5.1.1(v)** requires an app that offers account creation to
/// offer account deletion from inside the app. This is that path.
///
/// ## Order is the whole design
///
/// Remote data is destroyed BEFORE the Firebase user, and the user is deleted
/// LAST. That ordering is not cosmetic:
///
/// * Firestore and Storage rules authorise by `request.auth.uid`. Once the user
///   is gone, so is the only credential that can reach `/users/{uid}` — every
///   remaining document would be **permanently orphaned**, unreachable by the
///   user who owns it and by any later sign-in. Deleting the account first
///   would therefore guarantee the exact data retention this feature exists to
///   prevent.
/// * Local data is cleared last of all, because it is the only copy that
///   survives a crash mid-flow. If the process dies partway, the user still has
///   their records and can retry; the reverse order would lose them with the
///   cloud copy already gone.
///
/// ## Re-authentication is expected, and it happens FIRST
///
/// `User.delete()` rejects a credential older than a few minutes with
/// `requires-recent-login`, while the SESSION itself stays valid indefinitely.
/// So for any user who did not sign in moments ago — the common case — a
/// delete attempted on the existing credential fails by design.
///
/// The credential is therefore refreshed BEFORE anything is destroyed. It used
/// to be refreshed only as a RETRY, after `_deleteRemoteData` had already run,
/// which made a cancelled re-auth sheet catastrophic: every Firestore
/// collection, every receipt photo, the avatar and the user document were
/// already gone, the account survived, and the next sync simply re-uploaded
/// the local copy — so the user saw their cloud storage refill instead of the
/// account disappearing. A destructive flow must not depend on a credential it
/// has not yet confirmed it can get.
///
/// Refreshing first also costs nothing when it is unnecessary: a user who DID
/// just sign in re-authenticates silently on the same provider.
class DeleteAccountUseCase {
  final IAuthRepository _authRepository;
  final ISyncRemoteRepository _syncRemoteRepository;
  final IUserProfileRemoteRepository _profileRemoteRepository;
  final IUserProfileLocalRepository _profileLocalRepository;
  final FirebaseStorageService _storageService;
  final SyncEntityAdapters _adapters;
  final IReceiptLocalRepository _receiptLocalRepository;
  final ISettingsLocalRepository _settingsLocalRepository;
  final ReceiptImageStore _imageStore;
  final LoggerService _loggerService;

  const DeleteAccountUseCase({
    required IAuthRepository authRepository,
    required ISyncRemoteRepository syncRemoteRepository,
    required IUserProfileRemoteRepository profileRemoteRepository,
    required IUserProfileLocalRepository profileLocalRepository,
    required FirebaseStorageService storageService,
    required SyncEntityAdapters adapters,
    required IReceiptLocalRepository receiptLocalRepository,
    required ISettingsLocalRepository settingsLocalRepository,
    required ReceiptImageStore imageStore,
    required LoggerService loggerService,
  }) : this._(
         authRepository,
         syncRemoteRepository,
         profileRemoteRepository,
         profileLocalRepository,
         storageService,
         adapters,
         receiptLocalRepository,
         settingsLocalRepository,
         imageStore,
         loggerService,
       );

  const DeleteAccountUseCase._(
    this._authRepository,
    this._syncRemoteRepository,
    this._profileRemoteRepository,
    this._profileLocalRepository,
    this._storageService,
    this._adapters,
    this._receiptLocalRepository,
    this._settingsLocalRepository,
    this._imageStore,
    this._loggerService,
  );

  Future<Either<Failure, Unit>> call({
    required EAccountDeletionScope scope,
  }) async {
    final uid = _authRepository.currentUser?.uid;

    try {
      // BEFORE anything is destroyed. A cancelled sheet must leave the account
      // and its data exactly as they were — see the class doc.
      final authorised = await _ensureRecentLogin();
      if (authorised.isLeft()) return authorised;

      if (uid != null) {
        await _deleteRemoteData(uid);
      }

      final deleted = await _deleteUserWithRetry();
      if (deleted.isLeft()) return deleted;

      await _clearLocal(scope);

      return const Right(unit);
    } catch (error, stackTrace) {
      _loggerService.error(
        'Account deletion failed',
        error: error,
        stackTrace: stackTrace,
        name: 'Auth',
      );
      return Left(
        AccountDeletionFailure(diagnostic: error.toString()),
      );
    }
  }

  /// Destroys everything under `/users/{uid}` — all seven record collections,
  /// the receipt photos, and the profile document with its avatar.
  ///
  /// Driven off [SyncEntityAdapters] rather than a hand-written list, so an
  /// entity added later is covered by existing in the adapter list instead of
  /// by someone remembering to add a line here. A hardcoded list is how
  /// `DeleteAllRecordsUseCase` ended up clearing three of seven collections.
  Future<void> _deleteRemoteData(String uid) async {
    for (final adapter in _adapters.all()) {
      final rows = await adapter.readAllIncludingDeleted();
      final ids = rows.map(adapter.idOf).toList();
      await _syncRemoteRepository.deleteRecords(
        uid: uid,
        collection: adapter.collection,
        ids: ids,
      );
    }

    // Photos are keyed by what the BUCKET holds, not by local rows: a receipt
    // deleted on this device can still have its photo in the cloud, and a
    // local-row-driven sweep would leave exactly those behind.
    final photoIds = await _storageService.uploadedReceiptIds(uid);
    for (final receiptId in photoIds) {
      await _storageService.deleteReceiptPhoto(uid: uid, receiptId: receiptId);
    }

    await _profileRemoteRepository.deleteAvatar(uid);
    await _profileRemoteRepository.deleteUserDocument(uid);
  }

  /// Refreshes the credential up front so the destructive work below runs
  /// only once deletion is actually authorised.
  ///
  /// A failure here — most often the user dismissing the provider sheet — is
  /// returned as-is and nothing has been touched. [_deleteUserWithRetry] still
  /// keeps its own retry: the credential can age out between this call and the
  /// delete on a slow connection, and that late retry is harmless because by
  /// then the user has already proved they can re-authenticate.
  Future<Either<Failure, Unit>> _ensureRecentLogin() =>
      _authRepository.reauthenticate();

  /// Deletes the Firebase user, re-authenticating once if the credential is
  /// too old — which it almost always is. See the class doc.
  Future<Either<Failure, Unit>> _deleteUserWithRetry() async {
    final first = await _authRepository.deleteAccount();

    return first.fold((failure) async {
      if (!_needsRecentLogin(failure)) return Left(failure);

      final reauth = await _authRepository.reauthenticate();
      return reauth.fold(
        // A cancelled re-auth sheet propagates as-is, so the UI can stay quiet
        // about a choice the user made deliberately.
        (reauthFailure) => Left(reauthFailure),
        (_) => _authRepository.deleteAccount(),
      );
    }, (success) async => Right(success));
  }

  /// Firebase reports the stale-credential case as `requires-recent-login`;
  /// the code is carried on the failure's diagnostic by `_describe`.
  bool _needsRecentLogin(Failure failure) =>
      failure is AuthFailure &&
      failure.diagnostic.contains('requires-recent-login');

  /// Clears device state. The profile and avatar ALWAYS go — they are account
  /// identity, and keeping a deleted account's name and face on the device is
  /// the privacy leak this feature exists to close. Records go only when the
  /// user asked for [EAccountDeletionScope.everywhere].
  Future<void> _clearLocal(EAccountDeletionScope scope) async {
    await _profileLocalRepository.clear();

    if (!scope.clearsLocalRecords) return;

    // Receipt photo FILES are read before the rows are purged: the filename
    // lives on the row, so purging first would strand every image on disk with
    // nothing left pointing at it.
    final receipts = await _receiptLocalRepository.getAllIncludingDeleted();
    for (final receipt in receipts) {
      await _imageStore.delete(receipt.imagePath);
    }

    // HARD delete, never the repositories' soft delete: a tombstone exists to
    // PROPAGATE a deletion to a server that no longer has this account. There
    // is nothing left to tell, and the markers would just outlive the account.
    for (final adapter in _adapters.all()) {
      final rows = await adapter.readAllIncludingDeleted();
      for (final row in rows) {
        await adapter.purgeLocal(adapter.idOf(row));
      }
    }

    // `dataCleared` stops the category seed from silently repopulating an app
    // the user just emptied — the same guard `DeleteAllRecordsUseCase` sets.
    // `lastSyncedAt` is reset because the cursor belongs to a deleted account.
    final settings = await _settingsLocalRepository.get();
    await _settingsLocalRepository.save(
      settings.copyWith(dataCleared: true, lastSyncedAt: null),
    );
  }
}

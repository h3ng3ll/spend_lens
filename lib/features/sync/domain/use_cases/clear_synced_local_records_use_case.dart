import '../../../../core/models/e_sync_status.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../settings/domain/repositories/i_settings_local_repository.dart';
import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../adapters/sync_entity_adapters.dart';
import 'run_full_sync_use_case.dart';

/// Drops local copies of records the server already holds, on sign-out.
///
/// **Only `synced` rows are removed.** A row that is not synchronized
/// exists nowhere else — deleting it would destroy the user's only copy —
/// so it stays on the device and syncs once they sign in again. That
/// asymmetry is the entire safety property of this operation.
///
/// **Hard delete, never the repositories' soft delete.** `delete()` stamps
/// `pendingDelete` + `deletedAt` so a removal PROPAGATES; using it here
/// would push tombstones on the next sync and erase the user's cloud data —
/// the exact opposite of the intent. Every removal here goes through
/// `deleteLocalOnly`, which leaves no tombstone.
///
/// **Every synced entity, not just receipts.** It used to clear receipts,
/// their items and orphaned stores only — so after sign-out the receipt and
/// its photo disappeared while the EXPENSE the receipt created stayed on
/// Home, still naming the amount and store. Half-cleared is worse than not
/// cleared: the user is signed out and still looking at their spending.
/// Sweeping [SyncEntityAdapters] covers all seven and means a future entity
/// is included by existing in the adapter list, rather than by someone
/// remembering to add a line here.
///
/// Photos go too, because [DownloadReceiptPhotosUseCase] fetches them back
/// on the next sign-in. Without that download path this would lose images
/// permanently, which is why the two landed together.
///
/// **It syncs FIRST.** Without that this cleared almost nothing in practice:
/// records created since the last cycle are still `pendingCreate`, so the
/// `synced`-only rule (correctly) kept every one of them, and a user who
/// added a receipt and signed out saw nothing removed at all. Pushing first
/// turns "not synchronized yet" into "safely on the server", which is what
/// makes it eligible to be cleared.
///
/// A failed sync is not fatal: whatever did not reach the server simply
/// stays on the device, which is the same guarantee as before. A `Left`
/// means fewer rows qualify as `synced`, which the clearing rule already
/// handles — so the cycle's result is not inspected here at all.
class ClearSyncedLocalRecordsUseCase {
  final IReceiptLocalRepository _receiptLocalRepository;
  final SyncEntityAdapters _adapters;
  final ISettingsLocalRepository _settingsLocalRepository;
  final ReceiptImageStore _imageStore;
  final RunFullSyncUseCase _runFullSync;
  final FirebaseFirestoreService _firestoreService;
  final LoggerService _loggerService;

  const ClearSyncedLocalRecordsUseCase({
    required this._receiptLocalRepository,
    required this._adapters,
    required this._settingsLocalRepository,
    required this._imageStore,
    required this._runFullSync,
    required this._firestoreService,
    required this._loggerService,
  });

  /// Returns how many rows were cleared, across every synced entity.
  Future<int> call() async {
    await _publishPendingWork();

    // Photos first, while the receipt rows that name them still exist.
    // Doing this after the sweep would leave orphaned JPEGs no record
    // points at, and no way left to find them.
    await _clearSyncedPhotos();

    // BEFORE the sweep, so a crash mid-clear still leaves a cursor that
    // re-fetches rather than one that skips.
    await _resetPullCursor();

    var cleared = 0;
    for (final adapter in _adapters.all()) {
      for (final entity in await adapter.readAllIncludingDeleted()) {
        // The safety property: only rows the server provably holds. A row
        // with unpublished work exists NOWHERE else, so removing it would
        // destroy the user's only copy. It stays, and syncs on next sign-in.
        if (adapter.syncStatusOf(entity) != ESyncStatus.synced) continue;

        // HARD delete, never the repositories' soft delete: a tombstone
        // would publish on the next sync and erase the user's cloud data —
        // the exact opposite of the intent.
        await adapter.purgeLocal(adapter.idOf(entity));
        cleared++;
      }
    }

    return cleared;
  }

  /// Clears the incremental-pull cursor.
  ///
  /// Without this, signing back in restored NOTHING. `lastSyncedAt` means
  /// "this device already holds every record up to here" — but the sweep
  /// below just deleted those records, so the claim became false the moment
  /// it ran. The next sign-in then asked Firestore only for records NEWER
  /// than the cursor, got an empty page, and reported `upToDate` with an
  /// empty app while every document still sat in the account.
  ///
  /// The records are safe on the server (that is precisely why they were
  /// eligible for clearing), so the correct cursor for a device holding
  /// none of them is no cursor at all.
  Future<void> _resetPullCursor() async {
    final settings = await _settingsLocalRepository.get();
    await _settingsLocalRepository.save(
      settings.copyWith(lastSyncedAt: null),
    );
  }

  /// Deletes the image files of receipts that are about to be cleared.
  ///
  /// Gated on `synced` for the same reason the sweep is: a receipt that has
  /// not reached the server keeps its photo, because the download path
  /// could never bring that file back.
  Future<void> _clearSyncedPhotos() async {
    final receipts = await _receiptLocalRepository.getAllIncludingDeleted();
    for (final receipt in receipts) {
      if (receipt.syncStatus != ESyncStatus.synced) continue;
      await _imageStore.delete(receipt.imagePath);
    }
  }

  /// Pushes everything outstanding so it becomes eligible for clearing.
  ///
  /// Runs while the session is still alive — the caller invokes this BEFORE
  /// `signOut()`, so `currentUid` is still valid here.
  ///
  /// Returns NOTHING, deliberately. Success is not actionable: a failed
  /// cycle must never block sign-out, and the outcome is already absorbed by
  /// the `synced`-only rule that follows — fewer rows qualify, so more of
  /// them stay on the device, which is the conservative and correct result.
  /// Returning a `bool` no caller can act on would only invite someone to
  /// branch on it and skip the cleanup, which is exactly the wrong
  /// behaviour.
  ///
  /// The failure IS handled, though — it is LOGGED rather than discarded.
  /// `RunFullSyncUseCase` classifies it into a `Failure` and returns it;
  /// nothing in the sync feature logs, so dropping the `Left` here would
  /// erase the only record that a sign-out left unpushed work behind. That
  /// is precisely the case worth diagnosing later: the user signed out, the
  /// rows stayed local, and without this line nobody could tell why.
  Future<void> _publishPendingWork() async {
    final uid = _firestoreService.currentUid;
    if (uid == null || uid.isEmpty) {
      _loggerService.info(
        'ClearSyncedLocalRecords: no signed-in user — nothing to publish '
        'before sign-out.',
      );
      return;
    }

    final result = await _runFullSync(uid: uid);

    // The project's side order: Left = failure.
    result.fold(
      (failure) => _loggerService.warning(
        'ClearSyncedLocalRecords: pre-sign-out sync did not complete '
        '(${failure.message}). Unpushed rows stay on this device and are '
        'not eligible for clearing.',
      ),
      (report) => _loggerService.info(
        'ClearSyncedLocalRecords: pre-sign-out sync pushed '
        '${report.pushed} record(s).',
      ),
    );
  }
}

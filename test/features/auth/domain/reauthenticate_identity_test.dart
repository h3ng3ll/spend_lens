import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/failures/failure.dart';
import 'package:spend_lens/core/services/firebase/e_sync_collection.dart';
import 'package:spend_lens/core/services/firebase/firebase_storage_service.dart';
import 'package:spend_lens/core/services/logger_service.dart';
import 'package:spend_lens/core/services/receipt_image_store/receipt_image_store.dart';
import 'package:spend_lens/features/auth/domain/failures/auth_failures.dart';
import 'package:spend_lens/features/auth/domain/models/e_account_deletion_scope.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_local_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_remote_repository.dart';
import 'package:spend_lens/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/category/domain/models/category/category.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/product/domain/repositories/i_product_local_repository.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';
import 'package:spend_lens/features/category/domain/repositories/i_category_local_repository.dart';
import 'package:spend_lens/features/expense/domain/repositories/i_expense_local_repository.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/settings/domain/models/app_settings/app_settings.dart';
import 'package:spend_lens/features/settings/domain/repositories/i_settings_local_repository.dart';
import 'package:spend_lens/features/sync/domain/adapters/sync_entity_adapters.dart';
import 'package:spend_lens/features/sync/domain/repositories/i_sync_remote_repository.dart';

/// REGRESSION: account deletion could delete the WRONG Google account.
///
/// `FirebaseAuthRepository.reauthenticate()` did not re-authenticate — it
/// called `signInWithGoogle()`, a full `signInWithCredential(...)`. On
/// google_sign_in v7 `authenticate()` is always the interactive path and
/// accepts no account hint, so deleting an account opened a chooser listing
/// every Google account on the device.
///
/// The returned credential's uid was then discarded (`(_) => Right(unit)`),
/// so picking a different account silently swapped the session. The use case
/// had already captured the ORIGINAL uid, so it would try to wipe account A's
/// data using account B's token, and then call `currentUser.delete()` —
/// destroying B, the innocent account, while A survived untouched.
///
/// The repository now refuses a uid mismatch. This is the second layer: the
/// use case re-reads the session after the refresh and aborts before anything
/// is destroyed.
void main() {
  late List<String> order;
  late _RecordingAuth auth;
  late _RecordingSync sync;
  late _RecordingProfileRemote profileRemote;

  DeleteAccountUseCase buildUseCase() => DeleteAccountUseCase(
    authRepository: auth,
    syncRemoteRepository: sync,
    profileRemoteRepository: profileRemote,
    profileLocalRepository: _FakeProfileLocal(),
    storageService: _FakeStorage(),
    adapters: _emptyAdapters(),
    receiptLocalRepository: _FakeReceipts(),
    settingsLocalRepository: _FakeSettings(),
    imageStore: const ReceiptImageStore(),
    loggerService: LoggerService(),
  );

  setUp(() {
    order = [];
    auth = _RecordingAuth(order);
    sync = _RecordingSync(order);
    profileRemote = _RecordingProfileRemote(order);
  });

  test('a session that changes during re-auth destroys NOTHING', () async {
    auth.uidAfterReauth = 'user-b';

    final result = await buildUseCase().call(
      scope: EAccountDeletionScope.everywhere,
    );

    expect(result.isLeft(), isTrue);
    expect(
      order,
      isNot(contains('deleteRecords')),
      reason: "THE BUG: account A's data was wiped with account B's token",
    );
    expect(
      order,
      isNot(contains('deleteAccount')),
      reason: 'THE BUG: this deleted account B — the wrong account entirely',
    );
    expect(order, isNot(contains('deleteAvatar')));
    expect(order, isNot(contains('deleteUserDocument')));
  });

  test('the abort is reported, never silently treated as success', () async {
    auth.uidAfterReauth = 'user-b';

    final result = await buildUseCase().call(
      scope: EAccountDeletionScope.everywhere,
    );

    result.fold(
      (failure) => expect(failure, isA<AccountDeletionFailure>()),
      (_) => fail('a changed session must not report success'),
    );
  });

  test('an UNCHANGED session proceeds in the established order', () async {
    // The control: the guard must not block the normal path.
    await buildUseCase().call(scope: EAccountDeletionScope.everywhere);

    expect(order.first, 'reauthenticate');
    expect(order, contains('deleteRecords'));
    expect(
      order.indexOf('deleteRecords'),
      lessThan(order.indexOf('deleteAccount')),
      reason: 'remote data must go before the user, or it is orphaned by the '
          'rules that authorise on request.auth.uid',
    );
  });

  test('a signed-out session is not mistaken for a changed one', () async {
    // `currentUser` is null once the user is gone; that is not a mismatch.
    auth.uid = null;

    final result = await buildUseCase().call(
      scope: EAccountDeletionScope.everywhere,
    );

    expect(result.isRight(), isTrue);
  });
}

SyncEntityAdapters _emptyAdapters() => SyncEntityAdapters(
  receiptLocalRepository: _FakeReceipts(),
  receiptItemLocalRepository: _UnusedReceiptItems(),
  productLocalRepository: _UnusedProducts(),
  storeLocalRepository: _UnusedStores(),
  categoryLocalRepository: _UnusedCategories(),
  expenseLocalRepository: _UnusedExpenses(),
  priceObservationLocalRepository: _UnusedObservations(),
);

class _RecordingAuth implements IAuthRepository {
  final List<String> order;
  Failure? reauthFailure;

  /// The uid `currentUser` reports. `reauthenticate()` swaps it to
  /// [uidAfterReauth] when that is set, reproducing the session change a
  /// wrong pick from the Google account chooser used to cause.
  String? uid = 'user-a';
  String? uidAfterReauth;

  _RecordingAuth(this.order);

  // `currentUser` returns a Firebase `User`, which cannot be constructed in
  // a test — which is exactly why the use case reads `currentUid` instead.
  @override
  Null get currentUser => null;

  @override
  String? get currentUid => uid;

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    order.add('deleteAccount');
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> reauthenticate() async {
    order.add('reauthenticate');
    final failure = reauthFailure;
    if (failure != null) return Left(failure);
    // The defect being guarded: a re-auth that comes back as someone else.
    if (uidAfterReauth != null) uid = uidAfterReauth;
    return const Right(unit);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingSync implements ISyncRemoteRepository {
  final List<String> order;

  _RecordingSync(this.order);

  @override
  Future<void> deleteRecords({
    required String uid,
    required ESyncCollection collection,
    required List<String> ids,
  }) async {
    order.add('deleteRecords');
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingProfileRemote implements IUserProfileRemoteRepository {
  final List<String> order;

  _RecordingProfileRemote(this.order);

  @override
  Future<void> deleteAvatar(String uid) async => order.add('deleteAvatar');

  @override
  Future<void> deleteUserDocument(String uid) async =>
      order.add('deleteUserDocument');

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProfileLocal implements IUserProfileLocalRepository {
  @override
  Future<void> clear() async {}

  @override
  Future<String?> getAvatarFilename() async => null;

  @override
  Future<void> saveAvatarFilename(String? filename) async {}

  @override
  Stream<String?> watchAvatarFilename() => const Stream<String?>.empty();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStorage implements FirebaseStorageService {
  @override
  Future<Set<String>> uploadedReceiptIds(String uid) async => const {};

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceipts implements IReceiptLocalRepository {
  @override
  Future<List<Receipt>> getAllIncludingDeleted() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSettings implements ISettingsLocalRepository {
  @override
  Future<AppSettings> get() async => const AppSettings();

  @override
  Future<void> save(AppSettings settings) async {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedReceiptItems implements IReceiptItemLocalRepository {
  @override
  Future<List<ReceiptItem>> getAllIncludingDeleted() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedProducts implements IProductLocalRepository {
  @override
  Future<List<Product>> getAllIncludingDeleted() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedStores implements IStoreLocalRepository {
  @override
  Future<List<Store>> getAllIncludingDeleted() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedCategories implements ICategoryLocalRepository {
  @override
  Future<List<Category>> getAllIncludingDeleted() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedExpenses implements IExpenseLocalRepository {
  @override
  Future<List<Expense>> getAllIncludingDeleted() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedObservations implements IPriceObservationLocalRepository {
  @override
  Future<List<PriceObservation>> getAllIncludingDeleted() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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

/// REGRESSION: a CANCELLED re-auth sheet destroyed all remote data.
///
/// `DeleteAccountUseCase` ran `_deleteRemoteData` first and only then tried to
/// delete the Firebase user, refreshing the credential as a RETRY when
/// Firebase answered `requires-recent-login` — which it does for any user who
/// did not sign in moments ago, i.e. almost always.
///
/// So the real-device sequence was:
///
///     1. every Firestore collection deleted
///     2. every receipt photo deleted, the avatar and user document too
///     3. delete user -> requires-recent-login
///     4. Google sheet opens -> user cancels
///     5. abort
///
/// The account survived with its data gone, and the next sync re-uploaded the
/// local copy — the user watched their cloud storage refill instead of the
/// account disappearing. A destructive flow must not depend on a credential it
/// has not yet confirmed it can get.
///
/// This test drives the REAL use case. The pre-existing
/// `delete_account_use_case_test.dart` asserts ordering against a
/// `_TestableDeleteAccount` COPY of the logic, so it could not have caught
/// this: the production class was free to diverge from it, and did.
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

  test('a cancelled re-auth destroys NOTHING', () async {
    auth.reauthFailure = const AccountDeletionFailure(diagnostic: 'canceled');

    final result = await buildUseCase().call(
      scope: EAccountDeletionScope.everywhere,
    );

    expect(result.isLeft(), isTrue);
    expect(
      order,
      isNot(contains('deleteRecords')),
      reason: 'THE BUG: remote records were wiped before the credential was '
          'confirmed, so cancelling the sheet left the account alive and '
          'empty.',
    );
    expect(order, isNot(contains('deleteAvatar')));
    expect(order, isNot(contains('deleteUserDocument')));
    expect(order, isNot(contains('deleteAccount')));
  });

  test('re-authentication is the FIRST thing that happens', () async {
    await buildUseCase().call(scope: EAccountDeletionScope.everywhere);

    // The whole fix in one assertion: nothing precedes the credential check.
    expect(order.first, 'reauthenticate');
  });

  test('the account is deleted only after re-auth succeeds', () async {
    await buildUseCase().call(scope: EAccountDeletionScope.everywhere);

    expect(
      order.indexOf('reauthenticate'),
      lessThan(order.indexOf('deleteAccount')),
    );
  });

  test('a credential that ages out mid-flow is still retried', () async {
    // The late retry stays: the credential can expire between the pre-flight
    // refresh and the delete on a slow connection.
    auth.failFirstDeleteWith = const AccountDeletionFailure(
      diagnostic: 'requires-recent-login',
    );

    final result = await buildUseCase().call(
      scope: EAccountDeletionScope.everywhere,
    );

    expect(result.isRight(), isTrue);
    expect(order.where((e) => e == 'deleteAccount').length, 2);
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
  Failure? failFirstDeleteWith;
  Failure? reauthFailure;
  int _deleteCalls = 0;

  _RecordingAuth(this.order);

  @override
  Null get currentUser => null;

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    order.add('deleteAccount');
    _deleteCalls++;
    if (_deleteCalls == 1 && failFirstDeleteWith != null) {
      return Left(failFirstDeleteWith!);
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> reauthenticate() async {
    order.add('reauthenticate');
    final failure = reauthFailure;
    if (failure != null) return Left(failure);
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

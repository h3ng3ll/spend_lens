import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/services/firebase/firebase_storage_service.dart';
import 'package:spend_lens/core/services/store_logo_image_store/store_logo_image_store.dart';
import 'package:spend_lens/features/analytics/domain/models/price_observation/price_observation.dart';
import 'package:spend_lens/features/analytics/domain/repositories/i_price_observation_local_repository.dart';
import 'package:spend_lens/features/expense/domain/models/expense/expense.dart';
import 'package:spend_lens/features/expense/domain/repositories/i_expense_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';
import 'package:spend_lens/features/store/domain/use_cases/delete_store_use_case.dart';

/// REGRESSION: deleting a store orphaned its logo in Firebase Storage.
///
/// The user's report: cloud usage rose when a store logo was added and never
/// came back down after the store was deleted.
///
/// `DeleteStoreUseCase` tombstoned every RECORD — receipts, items, price
/// observations, expenses, the store — but never touched the image. A soft
/// delete propagates through Firestore, and nothing in the sync cycle
/// removes a Storage object: `purgePublishedDeletions` deletes documents
/// only. So the object stayed in `users/{uid}/stores/{id}.jpg` billed to the
/// user's quota, and because the record naming it was gone, no code path
/// could ever find it again.
void main() {
  late _FakeStores stores;
  late _FakeImageStore imageStore;
  late _RecordingStorage storage;

  final now = DateTime(2026, 9, 20);

  DeleteStoreUseCase buildUseCase() => DeleteStoreUseCase(
    storeLocalRepository: stores,
    expenseLocalRepository: _FakeExpenses(),
    receiptLocalRepository: _FakeReceipts(),
    receiptItemLocalRepository: _FakeReceiptItems(),
    priceObservationLocalRepository: _FakeObservations(),
    imageStore: imageStore,
    storageService: storage,
  );

  setUp(() {
    imageStore = _FakeImageStore();
    storage = _RecordingStorage();
    stores = _FakeStores()
      ..rows['s1'] = Store(
        id: 's1',
        name: 'Kaufland',
        logoFilename: 'store_s1.jpg',
        logoUrl: 'https://example/s1.jpg',
        updatedAt: now,
      );
  });

  test('deletes the remote logo object', () async {
    await buildUseCase().call('s1', uid: 'u1');

    expect(
      storage.deletedStoreIds,
      ['s1'],
      reason: 'THE BUG: the object survived every record that named it and '
          'kept consuming the quota',
    );
  });

  test('deletes the logo file on disk', () async {
    await buildUseCase().call('s1', uid: 'u1');

    expect(imageStore.deleted, ['store_s1.jpg']);
  });

  test('uses the STORED filename, not a derived one', () async {
    // A store saved under an older naming scheme still points at its own
    // file; deriving the name would miss it and leak the local copy.
    stores.rows['s1'] = stores.rows['s1']!.copyWith(
      logoFilename: 'legacy_name.jpg',
    );

    await buildUseCase().call('s1', uid: 'u1');

    expect(imageStore.deleted, ['legacy_name.jpg']);
  });

  test('touches no remote object when signed out', () async {
    await buildUseCase().call('s1', uid: '');

    expect(storage.deletedStoreIds, isEmpty);
    // The local file still goes — it was never uploaded under a uid.
    expect(imageStore.deleted, ['store_s1.jpg']);
  });

  test('still tombstones the store when the image delete fails', () async {
    storage.throwOnDelete = true;

    await buildUseCase().call('s1', uid: 'u1');

    expect(
      stores.deleted,
      ['s1'],
      reason: 'a half-deleted store — records gone, row remaining — is worse '
          'than an orphaned object the user cannot see',
    );
  });

  test('still deletes the store record on the happy path', () async {
    await buildUseCase().call('s1', uid: 'u1');

    expect(stores.deleted, ['s1']);
  });
}

class _FakeStores implements IStoreLocalRepository {
  final Map<String, Store> rows = {};
  final List<String> deleted = [];

  @override
  Future<Store?> getById(String id) async => rows[id];

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeImageStore implements StoreLogoImageStore {
  final List<String?> deleted = [];

  @override
  Future<void> delete(String? filename) async => deleted.add(filename);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingStorage implements FirebaseStorageService {
  final List<String> deletedStoreIds = [];
  bool throwOnDelete = false;

  @override
  Future<void> deleteStoreLogo({
    required String uid,
    required String storeId,
  }) async {
    if (throwOnDelete) throw Exception('storage unavailable');
    deletedStoreIds.add(storeId);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeExpenses implements IExpenseLocalRepository {
  @override
  Future<List<Expense>> getAll() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceipts implements IReceiptLocalRepository {
  @override
  Future<List<Receipt>> getAll() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceiptItems implements IReceiptItemLocalRepository {
  @override
  Future<void> delete(String id) async {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeObservations implements IPriceObservationLocalRepository {
  @override
  Future<List<PriceObservation>> getAll() async => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

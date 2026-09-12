import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/services/logger_service.dart';
import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/core/services/receipt_image_store/receipt_image_store.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/store/domain/models/store/store.dart';
import 'package:spend_lens/features/store/domain/repositories/i_store_local_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:spend_lens/core/failures/failure.dart';
import 'package:spend_lens/core/failures/sync_failures.dart';
import 'package:spend_lens/core/services/firebase/firebase_firestore_service.dart';
import 'package:spend_lens/features/sync/domain/use_cases/clear_synced_local_records_use_case.dart';
import 'package:spend_lens/features/sync/domain/use_cases/run_full_sync_use_case.dart';

/// The sign-out cleanup. This deletes user data, so its safety properties
/// are pinned rather than assumed.
void main() {
  late _FakeReceipts receipts;
  late _FakeItems items;
  late _FakeStores stores;
  late _RecordingImageStore imageStore;
  late _SpyFullSync fullSync;

  final timestamp = DateTime(2026, 9, 12);

  ClearSyncedLocalRecordsUseCase buildUseCase() =>
      ClearSyncedLocalRecordsUseCase(
        receiptLocalRepository: receipts,
        receiptItemLocalRepository: items,
        storeLocalRepository: stores,
        imageStore: imageStore,
        runFullSync: fullSync,
        firestoreService: _FakeFirestore(),
        loggerService: LoggerService(),
      );

  Receipt receipt(
    String id,
    ESyncStatus status, {
    String? storeId,
    List<String> itemIds = const [],
    String? imagePath,
  }) =>
      Receipt(
        id: id,
        storeId: storeId,
        purchasedAt: timestamp,
        itemsTotal: 10.0,
        currencyCode: 'MDL',
        itemIds: itemIds,
        imagePath: imagePath,
        updatedAt: timestamp,
        syncStatus: status,
      );

  Store store(String id, ESyncStatus status) =>
      Store(id: id, name: id, updatedAt: timestamp, syncStatus: status);

  setUp(() {
    receipts = _FakeReceipts();
    items = _FakeItems();
    stores = _FakeStores();
    imageStore = _RecordingImageStore();
    fullSync = _SpyFullSync();
  });

  test('removes synced receipts', () async {
    await receipts.save(receipt('r1', ESyncStatus.synced));

    final cleared = await buildUseCase()();

    expect(cleared, 1);
    expect(await receipts.getAll(), isEmpty);
  });

  test('KEEPS anything not synchronized', () async {
    // The whole safety property: an unsynced row exists nowhere else, so
    // deleting it would destroy the user's only copy.
    for (final status in const [
      ESyncStatus.pendingCreate,
      ESyncStatus.pendingUpdate,
      ESyncStatus.pendingDelete,
    ]) {
      receipts = _FakeReceipts();
      items = _FakeItems();
      stores = _FakeStores();
      imageStore = _RecordingImageStore();
      fullSync = _SpyFullSync();
      await receipts.save(receipt('r1', status));

      final cleared = await buildUseCase()();

      expect(cleared, 0, reason: '$status must survive sign-out');
      expect(await receipts.getAll(), hasLength(1), reason: '$status');
    }
  });

  test('never tombstones — no pendingDelete, no deletedAt is written',
      () async {
    // Using the repositories' soft delete here would push a tombstone on the
    // next sync and DESTROY the user's cloud copy. This is the single most
    // dangerous mistake available in this operation.
    await receipts.save(receipt('r1', ESyncStatus.synced));

    await buildUseCase()();

    expect(receipts.softDeleted, isEmpty);
    expect(receipts.hardDeleted, contains('r1'));
  });

  test('removes the receipt items belonging to a cleared receipt', () async {
    await receipts.save(
      receipt('r1', ESyncStatus.synced, itemIds: const ['i1', 'i2']),
    );
    await items.save(_item('i1'));
    await items.save(_item('i2'));
    await items.save(_item('other'));

    await buildUseCase()();

    final remaining = (await items.getAll()).map((i) => i.id).toList();
    expect(remaining, ['other']);
  });

  test('deletes the photo of a cleared receipt', () async {
    await receipts.save(
      receipt('r1', ESyncStatus.synced, imagePath: 'receipt_r1.jpg'),
    );

    await buildUseCase()();

    expect(imageStore.deleted, contains('receipt_r1.jpg'));
  });

  test('keeps the photo of a receipt that is not synchronized', () async {
    await receipts.save(
      receipt('r1', ESyncStatus.pendingCreate, imagePath: 'receipt_r1.jpg'),
    );

    await buildUseCase()();

    expect(imageStore.deleted, isEmpty);
  });

  group('stores', () {
    test('a synced store nothing references is cleared', () async {
      await stores.save(store('s1', ESyncStatus.synced));
      await receipts.save(
        receipt('r1', ESyncStatus.synced, storeId: 's1'),
      );

      await buildUseCase()();

      expect(await stores.getAll(), isEmpty);
    });

    test('a store a REMAINING receipt still points at is kept', () async {
      // Dropping it would leave that receipt naming a store this device no
      // longer has.
      await stores.save(store('s1', ESyncStatus.synced));
      await receipts.save(
        receipt('r1', ESyncStatus.synced, storeId: 's1'),
      );
      await receipts.save(
        receipt('r2', ESyncStatus.pendingCreate, storeId: 's1'),
      );

      await buildUseCase()();

      expect(await stores.getAll(), hasLength(1));
      expect(await receipts.getAll(), hasLength(1));
    });

    test('a store that is not synchronized is kept regardless', () async {
      await stores.save(store('s1', ESyncStatus.pendingCreate));

      await buildUseCase()();

      expect(await stores.getAll(), hasLength(1));
    });
  });

  group('publishing before clearing', () {
    // Without this the cleanup removed almost nothing: rows created since
    // the last cycle are still pendingCreate, so the synced-only rule kept
    // every one of them and signing out appeared to do nothing at all.
    test('runs a sync before deciding what to clear', () async {
      await receipts.save(receipt('r1', ESyncStatus.synced));

      await buildUseCase()();

      expect(fullSync.callCount, 1);
    });

    test('a failed sync still clears what was already synced', () async {
      fullSync.shouldFail = true;
      await receipts.save(receipt('r1', ESyncStatus.synced));

      final cleared = await buildUseCase()();

      expect(cleared, 1, reason: 'r1 was already safe on the server');
    });

    test('a failed sync keeps everything still unsynchronized', () async {
      // The conservative outcome: nothing reached the server, so nothing is
      // eligible to be dropped.
      fullSync.shouldFail = true;
      await receipts.save(receipt('r1', ESyncStatus.pendingCreate));

      expect(await buildUseCase()(), 0);
      expect(await receipts.getAll(), hasLength(1));
    });
  });
}

ReceiptItem _item(String id) => ReceiptItem(
      id: id,
      rawName: id,
      normalizedName: id,
      quantity: 1.0,
      lineTotal: 1.0,
      confidence: 1.0,
      lineIndex: 0,
      updatedAt: DateTime(2026, 9, 12),
    );

class _RecordingImageStore implements ReceiptImageStore {
  final List<String> deleted = [];

  @override
  Future<void> delete(String? filename) async {
    if (filename != null && filename.isNotEmpty) deleted.add(filename);
  }

  @override
  Future<File?> resolve(String? filename) async => null;

  @override
  Future<String> save({
    required String receiptId,
    required Uint8List bytes,
  }) async =>
      'receipt_$receiptId.jpg';

  @override
  Future<String?> renameToReceipt({
    required String receiptId,
    required String? filename,
  }) async =>
      filename;
}

class _FakeReceipts implements IReceiptLocalRepository {
  final Map<String, Receipt> _store = {};
  final List<String> hardDeleted = [];
  final List<String> softDeleted = [];

  @override
  Future<List<Receipt>> getAll() async => _store.values.toList();

  @override
  Future<Receipt?> getById(String id) async => _store[id];

  @override
  Future<void> save(Receipt receipt, {bool markPending = true}) async =>
      _store[receipt.id] = receipt;

  @override
  Future<void> delete(String id) async {
    softDeleted.add(id);
    _store.remove(id);
  }

  @override
  Future<void> deleteLocalOnly(String id) async {
    hardDeleted.add(id);
    _store.remove(id);
  }

  @override
  Future<List<Receipt>> getAllIncludingDeleted() async =>
      _store.values.toList();

  @override
  Future<List<Receipt>> getPending() async => const [];

  @override
  Future<void> saveAll(List<Receipt> items, {bool markPending = true}) async {
    for (final item in items) {
      _store[item.id] = item;
    }
  }

  @override
  Stream<List<Receipt>> watchAll() => Stream.value(_store.values.toList());
}

class _FakeItems implements IReceiptItemLocalRepository {
  final Map<String, ReceiptItem> _store = {};

  @override
  Future<List<ReceiptItem>> getAll() async => _store.values.toList();

  @override
  Future<ReceiptItem?> getById(String id) async => _store[id];

  @override
  Future<void> save(ReceiptItem item, {bool markPending = true}) async =>
      _store[item.id] = item;

  @override
  Future<void> delete(String id) async => _store.remove(id);

  @override
  Future<void> deleteLocalOnly(String id) async => _store.remove(id);

  @override
  Future<List<ReceiptItem>> getAllIncludingDeleted() async =>
      _store.values.toList();

  @override
  Future<List<ReceiptItem>> getPending() async => const [];

  @override
  Future<void> saveAll(
    List<ReceiptItem> items, {
    bool markPending = true,
  }) async {
    for (final item in items) {
      _store[item.id] = item;
    }
  }

  @override
  Stream<List<ReceiptItem>> watchAll() =>
      Stream.value(_store.values.toList());

  @override
  Stream<List<ReceiptItem>> watchByReceiptId(List<String> itemIds) =>
      Stream.value(
        _store.values.where((item) => itemIds.contains(item.id)).toList(),
      );
}

class _FakeStores implements IStoreLocalRepository {
  final Map<String, Store> _store = {};

  @override
  Future<List<Store>> getAll() async => _store.values.toList();

  @override
  Future<Store?> getById(String id) async => _store[id];

  @override
  Future<void> save(Store store, {bool markPending = true}) async =>
      _store[store.id] = store;

  @override
  Future<void> delete(String id) async => _store.remove(id);

  @override
  Future<void> deleteLocalOnly(String id) async => _store.remove(id);

  @override
  Future<List<Store>> getAllIncludingDeleted() async => _store.values.toList();

  @override
  Future<List<Store>> getPending() async => const [];

  @override
  Future<void> saveAll(List<Store> items, {bool markPending = true}) async {
    for (final item in items) {
      _store[item.id] = item;
    }
  }

  @override
  Stream<List<Store>> watchAll() => Stream.value(_store.values.toList());
}

/// Records whether the cleanup published outstanding work first.
class _SpyFullSync implements RunFullSyncUseCase {
  int callCount = 0;

  /// Returns `Left` — the project's side order, Left = failure. The use case
  /// signals failure this way rather than throwing, so the test does too.
  bool shouldFail = false;

  @override
  Future<Either<Failure, SyncReport>> call({
    required String uid,
    bool fullResync = false,
  }) async {
    callCount++;
    if (shouldFail) return const Left(SyncOfflineFailure());
    return const Right(SyncReport(pushed: 0, pulled: 0));
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirestore implements FirebaseFirestoreService {
  @override
  String? get currentUid => 'u1';

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

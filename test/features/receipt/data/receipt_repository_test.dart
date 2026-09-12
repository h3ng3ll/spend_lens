import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/models/e_sync_status.dart';
import 'package:spend_lens/core/services/receipt_image_store/receipt_image_store.dart';
import 'package:spend_lens/core/services/receipt_size_calculator.dart';
import 'package:spend_lens/features/receipt/data/repositories/receipt_repository.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt_item/receipt_item.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_item_local_repository.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';

/// `ReceiptRepository.storageInfo` — the per-receipt figures behind the
/// storage details page.
void main() {
  late _FakeReceiptRepo receipts;
  late _FakeItemRepo items;
  late _FakeImageStore imageStore;
  late Directory tempDir;

  final timestamp = DateTime(2026, 9, 11);

  ReceiptRepository buildRepository() => ReceiptRepository(
        receiptLocalRepository: receipts,
        receiptItemLocalRepository: items,
        imageStore: imageStore,
        sizeCalculator: const ReceiptSizeCalculator(),
      );

  Receipt receipt({
    String? imagePath,
    List<String> itemIds = const [],
    ESyncStatus syncStatus = ESyncStatus.synced,
  }) =>
      Receipt(
        id: 'receipt-1',
        purchasedAt: timestamp,
        itemsTotal: 110.10,
        currencyCode: 'MDL',
        imagePath: imagePath,
        itemIds: itemIds,
        updatedAt: timestamp,
        syncStatus: syncStatus,
      );

  setUp(() async {
    receipts = _FakeReceiptRepo();
    items = _FakeItemRepo();
    tempDir = await Directory.systemTemp.createTemp('receipt_repo_test');
    imageStore = _FakeImageStore(tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  test('a missing receipt returns null rather than throwing', () async {
    expect(await buildRepository().storageInfo('nope'), isNull);
  });

  test('a receipt with no photo reports zero photo bytes but real document '
      'bytes', () async {
    await receipts.save(receipt());

    final info = await buildRepository().storageInfo('receipt-1');

    expect(info, isNotNull);
    expect(info!.photoBytes, 0);
    expect(info.hasPhoto, isFalse);
    expect(
      info.documentBytes,
      greaterThan(0),
      reason: 'The record itself still occupies space even with no photo.',
    );
  });

  test('photo bytes are the real file length', () async {
    final bytes = List<int>.filled(2048, 7);
    final file = File('${tempDir.path}/receipt_receipt-1.jpg');
    await file.writeAsBytes(bytes);

    await receipts.save(receipt(imagePath: 'receipt_receipt-1.jpg'));

    final info = await buildRepository().storageInfo('receipt-1');

    expect(info!.photoBytes, 2048);
    expect(info.hasPhoto, isTrue);
  });

  test('a receipt naming a file that is gone reports zero, not an error',
      () async {
    // An OS purge or a restore from backup leaves the name behind.
    await receipts.save(receipt(imagePath: 'receipt_missing.jpg'));

    final info = await buildRepository().storageInfo('receipt-1');

    expect(info!.photoBytes, 0);
  });

  test('document bytes cover the receipt AND its items', () async {
    await receipts.save(receipt(itemIds: const ['i1', 'i2']));
    await items.save(_item('i1', 'Milk 1L'));
    await items.save(_item('i2', 'Bread'));
    // Belongs to a different receipt — must not be counted.
    await items.save(_item('other', 'Not mine'));

    final withItems = await buildRepository().storageInfo('receipt-1');

    await receipts.save(receipt());
    final withoutItems = await buildRepository().storageInfo('receipt-1');

    expect(withItems!.documentBytes, greaterThan(withoutItems!.documentBytes));
  });

  test('sync status is carried through', () async {
    await receipts.save(receipt(syncStatus: ESyncStatus.pendingCreate));

    final info = await buildRepository().storageInfo('receipt-1');

    expect(info!.syncStatus, ESyncStatus.pendingCreate);
    expect(
      info.isPhotoUploaded,
      isFalse,
      reason: 'A row still pending has not reached the bucket.',
    );
  });

  test('a synced receipt reports its photo as uploaded', () async {
    await receipts.save(receipt(syncStatus: ESyncStatus.synced));

    final info = await buildRepository().storageInfo('receipt-1');

    expect(info!.isPhotoUploaded, isTrue);
  });
}

ReceiptItem _item(String id, String name) => ReceiptItem(
      id: id,
      rawName: name,
      normalizedName: name,
      quantity: 1.0,
      lineTotal: 22.90,
      confidence: 1.0,
      lineIndex: 0,
      updatedAt: DateTime(2026, 9, 11),
    );

class _FakeImageStore implements ReceiptImageStore {
  final Directory _dir;

  _FakeImageStore(this._dir);

  @override
  Future<File?> resolve(String? filename) async {
    if (filename == null || filename.isEmpty) return null;
    final file = File('${_dir.path}/$filename');
    return file.existsSync() ? file : null;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceiptRepo implements IReceiptLocalRepository {
  final Map<String, Receipt> _store = {};

  @override
  Future<List<Receipt>> getAll() async => _store.values.toList();

  @override
  Future<Receipt?> getById(String id) async => _store[id];

  @override
  Future<void> save(Receipt receipt, {bool markPending = true}) async =>
      _store[receipt.id] = receipt;

  @override
  Future<void> delete(String id) async => _store.remove(id);

  @override
  Future<void> deleteLocalOnly(String id) async =>
      _store.remove(id);

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

class _FakeItemRepo implements IReceiptItemLocalRepository {
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
  Future<void> deleteLocalOnly(String id) async =>
      _store.remove(id);

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

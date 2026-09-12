import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/services/firebase/firebase_storage_service.dart';
import 'package:spend_lens/core/services/receipt_image_store/receipt_image_store.dart';
import 'package:spend_lens/features/receipt/domain/models/receipt/receipt.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/sync/domain/use_cases/download_receipt_photos_use_case.dart';

/// Restoring photos onto a device that lost them.
///
/// Without this the cloud copy was a one-way archive: the sign-out cleanup
/// (and any reinstall) would lose images permanently.
void main() {
  late _FakeReceipts receipts;
  late _FakeImageStore imageStore;
  late _FakeStorage storage;

  final timestamp = DateTime(2026, 9, 12);

  DownloadReceiptPhotosUseCase buildUseCase() => DownloadReceiptPhotosUseCase(
        receiptLocalRepository: receipts,
        imageStore: imageStore,
        storageService: storage,
      );

  Receipt receipt(String id, {String? imagePath}) => Receipt(
        id: id,
        purchasedAt: timestamp,
        itemsTotal: 10.0,
        currencyCode: 'MDL',
        imagePath: imagePath,
        updatedAt: timestamp,
      );

  setUp(() {
    receipts = _FakeReceipts();
    imageStore = _FakeImageStore();
    storage = _FakeStorage();
  });

  test('restores a photo that is missing from disk', () async {
    await receipts.save(receipt('r1', imagePath: 'receipt_r1.jpg'));
    storage.objects['r1'] = Uint8List.fromList([1, 2, 3]);

    final downloaded = await buildUseCase()(uid: 'u1');

    expect(downloaded, 1);
    expect(imageStore.saved, contains('r1'));
  });

  test('does not re-download a photo already on disk', () async {
    // The reason this needs no stored flag: the filesystem is the record.
    await receipts.save(receipt('r1', imagePath: 'receipt_r1.jpg'));
    imageStore.onDisk.add('receipt_r1.jpg');
    storage.objects['r1'] = Uint8List.fromList([1, 2, 3]);

    final downloaded = await buildUseCase()(uid: 'u1');

    expect(downloaded, 0);
    expect(storage.requested, isEmpty);
  });

  test('skips a receipt that never had a photo', () async {
    await receipts.save(receipt('r1'));

    expect(await buildUseCase()(uid: 'u1'), 0);
    expect(storage.requested, isEmpty);
  });

  test('a missing cloud object is skipped, not an error', () async {
    // Normal for a receipt whose photo never uploaded — the account was
    // full, say.
    await receipts.save(receipt('r1', imagePath: 'receipt_r1.jpg'));

    expect(await buildUseCase()(uid: 'u1'), 0);
    expect(imageStore.saved, isEmpty);
  });

  test('a failed download never throws and leaves the rest running',
      () async {
    await receipts.save(receipt('r1', imagePath: 'receipt_r1.jpg'));
    await receipts.save(receipt('r2', imagePath: 'receipt_r2.jpg'));
    storage.failFor.add('r1');
    storage.objects['r2'] = Uint8List.fromList([9]);

    final downloaded = await buildUseCase()(uid: 'u1');

    expect(downloaded, 1, reason: 'r2 must still be restored');
    expect(imageStore.saved, contains('r2'));
  });
}

class _FakeStorage implements FirebaseStorageService {
  final Map<String, Uint8List> objects = {};
  final Set<String> failFor = {};
  final List<String> requested = [];

  @override
  Future<Uint8List?> downloadReceiptPhoto({
    required String uid,
    required String receiptId,
  }) async {
    requested.add(receiptId);
    if (failFor.contains(receiptId)) throw StateError('network down');
    return objects[receiptId];
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeImageStore implements ReceiptImageStore {
  final Set<String> onDisk = {};
  final List<String> saved = [];

  @override
  Future<File?> resolve(String? filename) async {
    if (filename == null || !onDisk.contains(filename)) return null;
    return File(filename);
  }

  @override
  Future<String> save({
    required String receiptId,
    required Uint8List bytes,
  }) async {
    saved.add(receiptId);
    return 'receipt_$receiptId.jpg';
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReceipts implements IReceiptLocalRepository {
  final Map<String, Receipt> _store = {};

  @override
  Future<List<Receipt>> getAll() async => _store.values.toList();

  @override
  Future<void> save(Receipt receipt, {bool markPending = true}) async =>
      _store[receipt.id] = receipt;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

import 'dart:io';

import '../../../../core/models/e_sync_status.dart';
import '../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../../core/services/receipt_size_calculator.dart';
import '../../domain/models/receipt/receipt.dart';
import '../../domain/models/receipt_storage_info/receipt_storage_info.dart';
import '../../domain/repositories/i_receipt_item_local_repository.dart';
import '../../domain/repositories/i_receipt_local_repository.dart';
import '../../domain/repositories/i_receipt_repository.dart';

/// [IReceiptRepository] over the local box, the on-disk photo, and the
/// receipt's own sync state.
///
/// Composes rather than reimplements: reads still go through
/// [IReceiptLocalRepository] (the one Hive owner for this model), items
/// through [IReceiptItemLocalRepository], the photo through
/// [ReceiptImageStore], and document sizing through [ReceiptSizeCalculator].
/// Nothing here opens a box itself.
class ReceiptRepository implements IReceiptRepository {
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final ReceiptImageStore _imageStore;
  final ReceiptSizeCalculator _sizeCalculator;

  const ReceiptRepository({
    required this._receiptLocalRepository,
    required this._receiptItemLocalRepository,
    required this._imageStore,
    required this._sizeCalculator,
  });

  @override
  Future<Receipt?> getById(String id) => _receiptLocalRepository.getById(id);

  @override
  Stream<List<Receipt>> watchAll() => _receiptLocalRepository.watchAll();

  @override
  Future<ReceiptStorageInfo?> storageInfo(String id) async {
    final receipt = await _receiptLocalRepository.getById(id);
    if (receipt == null) return null;

    final allItems = await _receiptItemLocalRepository.getAll();
    final itemIds = receipt.itemIds.toSet();
    final items = allItems
        .where((item) => itemIds.contains(item.id))
        .toList();

    return ReceiptStorageInfo(
      syncStatus: receipt.syncStatus,
      photoBytes: await _photoBytes(receipt),
      documentBytes: _sizeCalculator.documentBytes(
        receipt: receipt,
        items: items,
      ),
      // DERIVED from the local sync marker, never queried from Firebase.
      // The honest check would be
      // `FirebaseStorageService.uploadedReceiptIds(uid)`, but that lists the
      // WHOLE bucket — an unbounded network call every time a detail screen
      // opens, to answer one boolean. The marker is a close proxy: the sync
      // cycle uploads photos for rows it has pushed, so a `synced` row's
      // photo is normally present.
      //
      // It can be wrong in one direction: a row can read `synced` while its
      // photo upload was skipped (an unreadable file, a transient error —
      // `UploadReceiptPhotosUseCase` deliberately never fails a sync over a
      // photo). The next cycle retries, so this self-corrects; the UI must
      // not present it as a guarantee.
      isPhotoUploaded: receipt.syncStatus == ESyncStatus.synced,
    );
  }

  /// Real bytes of the photo on disk, or 0 when there is none.
  ///
  /// A receipt naming a file the filesystem no longer has (an OS purge, a
  /// restore from backup) reports 0 rather than throwing — the photo is
  /// simply not costing anything here any more.
  Future<int> _photoBytes(Receipt receipt) async {
    final path = receipt.imagePath;
    if (path == null || path.isEmpty) return 0;

    final File? file = await _imageStore.resolve(path);
    if (file == null) return 0;

    return file.length();
  }
}

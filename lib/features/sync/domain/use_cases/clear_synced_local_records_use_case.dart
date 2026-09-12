import '../../../../core/models/e_sync_status.dart';
import '../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';

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
/// Photos go too, because [DownloadReceiptPhotosUseCase] fetches them back
/// on the next sign-in. Without that download path this would lose images
/// permanently, which is why the two landed together.
class ClearSyncedLocalRecordsUseCase {
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final ReceiptImageStore _imageStore;

  const ClearSyncedLocalRecordsUseCase({
    required this._receiptLocalRepository,
    required this._receiptItemLocalRepository,
    required this._storeLocalRepository,
    required this._imageStore,
  });

  /// Returns how many receipts were cleared.
  Future<int> call() async {
    final receipts = await _receiptLocalRepository.getAll();

    final cleared = <String>{};
    for (final receipt in receipts) {
      if (receipt.syncStatus != ESyncStatus.synced) continue;

      // The photo first: if this throws we have not yet dropped the row, so
      // a retry still knows the file is owed. The reverse order would leave
      // an orphaned JPEG no record points at.
      await _imageStore.delete(receipt.imagePath);

      for (final itemId in receipt.itemIds) {
        await _receiptItemLocalRepository.deleteLocalOnly(itemId);
      }
      await _receiptLocalRepository.deleteLocalOnly(receipt.id);
      cleared.add(receipt.id);
    }

    await _clearOrphanedStores();

    return cleared.length;
  }

  /// Removes synced stores nothing local still points at.
  ///
  /// Re-reads the receipts AFTER the deletions above, so "still referenced"
  /// means referenced by what actually remains. A store a
  /// not-synchronized receipt points at is kept — dropping it would leave
  /// that receipt naming a store this device no longer has.
  Future<void> _clearOrphanedStores() async {
    final remaining = await _receiptLocalRepository.getAll();
    final referenced = {
      for (final receipt in remaining)
        if (receipt.storeId != null) receipt.storeId!,
    };

    final stores = await _storeLocalRepository.getAll();
    for (final store in stores) {
      if (store.syncStatus != ESyncStatus.synced) continue;
      if (referenced.contains(store.id)) continue;

      await _storeLocalRepository.deleteLocalOnly(store.id);
    }
  }
}

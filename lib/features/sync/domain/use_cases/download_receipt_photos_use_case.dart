import 'dart:typed_data';

import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';

/// Restores receipt photos that exist in the cloud but not on this device.
///
/// The mirror of [UploadReceiptPhotosUseCase], and the half that makes the
/// cloud copy a real BACKUP. Before it existed, photos only ever travelled
/// one way: a device that lost its files — a reinstall, a restore, or the
/// sign-out cleanup that clears synced records — had no way to get them
/// back, even though the bytes were sitting in Storage.
///
/// **Stateless and idempotent**, the same way the upload is: it asks the
/// FILESYSTEM what is missing rather than tracking a downloaded flag, so
/// re-running it fetches nothing twice and no schema change is needed.
///
/// **A failed download never fails the sync.** The record's data is already
/// intact — only its image is missing — so a transient error leaves the
/// photo absent and the next cycle retries it. That mirrors the upload
/// pass's contract exactly.
class DownloadReceiptPhotosUseCase {
  final IReceiptLocalRepository _receiptLocalRepository;
  final ReceiptImageStore _imageStore;
  final FirebaseStorageService _storageService;

  const DownloadReceiptPhotosUseCase({
    required this._receiptLocalRepository,
    required this._imageStore,
    required this._storageService,
  });

  /// Returns how many photos were restored this cycle.
  Future<int> call({required String uid}) async {
    final receipts = await _receiptLocalRepository.getAll();

    var downloaded = 0;
    for (final receipt in receipts) {
      final path = receipt.imagePath;
      // A receipt that never had a photo has nothing to restore.
      if (path == null || path.isEmpty) continue;

      try {
        // Already on disk — the common case, and the reason this needs no
        // stored flag.
        if (await _imageStore.resolve(path) != null) continue;

        final Uint8List? bytes = await _storageService.downloadReceiptPhoto(
          uid: uid,
          receiptId: receipt.id,
        );
        // The object is not in the bucket. Normal for a receipt whose photo
        // never uploaded (the account was full, or it is still pending), so
        // it is skipped rather than treated as a failure.
        if (bytes == null) continue;

        await _imageStore.save(receiptId: receipt.id, bytes: bytes);
        downloaded++;
      } catch (_) {
        // Skipped, not fatal — see the class doc. Nothing local is marked,
        // so the next cycle retries it.
        continue;
      }
    }

    return downloaded;
  }
}

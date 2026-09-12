import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';

/// Uploads receipt photos that exist on THIS device but not yet in the
/// user's cloud bucket.
///
/// **Why this exists.** `FirebaseStorageService.uploadReceiptPhoto` had no
/// callers at all: photos were written to the local filesystem by
/// `ReceiptImageStore` and the sync cycle pushed only Firestore DOCUMENTS,
/// never the images. So the bucket stayed empty, Profile's storage bar
/// honestly measured it as 0 MB of the quota, and the Premium copy's
/// promise of "cloud storage" for receipt photos was not actually kept —
/// the photos only ever lived on one device and a reinstall lost them.
///
/// **Stateless and idempotent.** Rather than tracking an
/// `isPhotoUploaded` flag on [Receipt] — a Hive model change carrying the
/// adapter-regeneration hazards hive_rules.md documents — this asks the
/// bucket which ids it already holds and uploads only the difference. A
/// re-run uploads nothing twice.
///
/// **A failed photo never fails the sync — with ONE exception.** Records are
/// the sync's real payload, so a photo that cannot upload (a purged file, a
/// transient network error) is skipped and retried next cycle; letting one
/// unreadable JPEG abort the whole cycle would strand the user's DATA over
/// an image.
///
/// A QUOTA rejection is different and rethrows. It is not transient: every
/// remaining photo in this pass will fail for the same reason, so continuing
/// burns bandwidth on certain failures and — worse — the cycle still reports
/// success, leaving the user with no idea why their photos never arrive.
/// Rethrowing lets `classifySyncError` turn it into
/// `SyncQuotaExceededFailure`, and the affected receipts stay honestly
/// marked as not synchronized.
class UploadReceiptPhotosUseCase {
  final IReceiptLocalRepository _receiptLocalRepository;
  final ReceiptImageStore _imageStore;
  final FirebaseStorageService _storageService;

  const UploadReceiptPhotosUseCase({
    required this._receiptLocalRepository,
    required this._imageStore,
    required this._storageService,
  });

  /// Returns how many photos were uploaded this cycle.
  Future<int> call({required String uid}) async {
    final receipts = await _receiptLocalRepository.getAll();
    final withPhotos = receipts.where(
      (receipt) => (receipt.imagePath ?? '').isNotEmpty,
    );
    if (withPhotos.isEmpty) return 0;

    final alreadyUploaded = await _storageService.uploadedReceiptIds(uid);

    var uploaded = 0;
    for (final receipt in withPhotos) {
      if (alreadyUploaded.contains(receipt.id)) continue;

      try {
        final File? file = await _imageStore.resolve(receipt.imagePath);
        // The receipt still names a file the filesystem no longer has (an
        // OS purge, a restore from backup). Nothing to upload, and not an
        // error worth failing a sync over.
        if (file == null) continue;

        await _storageService.uploadReceiptPhoto(
          uid: uid,
          receiptId: receipt.id,
          bytes: await file.readAsBytes(),
        );
        uploaded++;
      } on FirebaseException catch (error) {
        // The account is full. Every remaining photo fails identically, so
        // stop and surface it rather than looping — see the class doc.
        if (error.code == 'resource-exhausted') rethrow;
        continue;
      } catch (_) {
        // Skipped, not fatal — see the class doc. The next cycle retries it
        // because nothing local was marked as done.
        continue;
      }
    }

    return uploaded;
  }
}

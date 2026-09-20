import 'dart:typed_data';

import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/product_image_store/product_image_store.dart';
import '../../../product/domain/repositories/i_product_local_repository.dart';

/// Restores product photos that exist in the cloud but not on this device.
///
/// The counterpart to the upload, which happens inline in
/// `SaveProductImageUseCase` at the moment the user saves — a product photo
/// is picked rarely and deliberately, unlike receipt photos, which arrive in
/// bulk from scanning and therefore need their own batched upload pass.
///
/// This half is what makes the cloud copy a real BACKUP: without it, a photo
/// only ever lived on the device that set it, and a reinstall or a second
/// device would show the initial-letter tile forever even though the bytes
/// were sitting in Storage.
///
/// **Stateless and idempotent**, exactly like `DownloadStoreLogosUseCase`: it
/// asks the FILESYSTEM what is missing rather than tracking a downloaded
/// flag, so re-running it fetches nothing twice and needs no schema change.
///
/// **A failed download never fails the sync.** The product's data is already
/// intact — only its photo is missing — so a transient error leaves the image
/// absent and the next cycle retries it.
class DownloadProductImagesUseCase {
  final IProductLocalRepository _productLocalRepository;
  final ProductImageStore _imageStore;
  final FirebaseStorageService _storageService;

  const DownloadProductImagesUseCase({
    required IProductLocalRepository productLocalRepository,
    required ProductImageStore imageStore,
    required FirebaseStorageService storageService,
  }) : this._(productLocalRepository, imageStore, storageService);

  const DownloadProductImagesUseCase._(
    this._productLocalRepository,
    this._imageStore,
    this._storageService,
  );

  /// Returns how many photos were restored this cycle.
  Future<int> call({required String uid}) async {
    final products = await _productLocalRepository.getAll();

    var downloaded = 0;
    for (final product in products) {
      // A product whose photo was never uploaded has nothing to restore. The
      // URL is the signal rather than the filename, because the filename is
      // this device's local pointer and is exactly what a fresh device lacks.
      if (product.imageUrl.isEmpty) continue;

      try {
        final expected = _imageStore.filenameFor(product.id);
        // Already on disk — the common case, and the reason this needs no
        // stored flag.
        if (await _imageStore.resolve(expected) != null) continue;

        final Uint8List? bytes = await _storageService.downloadProductImage(
          uid: uid,
          productId: product.id,
        );
        // The object is not in the bucket. Normal for a product whose upload
        // never completed, so it is skipped rather than treated as a failure.
        if (bytes == null) continue;

        final filename = await _imageStore.save(
          productId: product.id,
          bytes: bytes,
        );

        // The row now names a file this device actually has. Written WITHOUT
        // marking it pending: this is a local pointer catching up to a remote
        // fact, not a user edit, and echoing it back would loop the sync.
        await _productLocalRepository.save(
          product.copyWith(imageFilename: filename),
          markPending: false,
        );
        downloaded++;
      } catch (_) {
        // Skipped, not fatal — see the class doc. Nothing local is marked, so
        // the next cycle retries it.
        continue;
      }
    }

    return downloaded;
  }
}

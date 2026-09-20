import 'dart:typed_data';

import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/image_compression_service.dart';
import '../../../../core/services/product_image_store/product_image_store.dart';
import '../models/product/product.dart';

/// Product photo budget. Matches the store logo's rather than the receipt's:
/// a product photo is rendered at most at 96dp and is read on every product
/// row, whereas a receipt photo is opened deliberately and must stay legible
/// enough to read.
const int _kProductImageTargetKB = 100;

/// Longer-edge bound for the stored photo.
///
/// The photo renders at 96dp at most, so 512px covers a 3x display with room
/// to spare. Bounding it is not only a size optimisation: without a resize,
/// quality is the compressor's only lever, so a full-resolution phone photo
/// runs every quality step, each decoding and re-encoding millions of pixels
/// — long enough for Android to raise an ANR and kill the app mid-save.
const int _kProductImageMaxDimension = 512;

/// Compresses a picked photo, commits it to disk for [Product], and uploads
/// it, returning the product with `imageFilename` and `imageUrl` updated.
///
/// The compressed image is written to DISK via [ProductImageStore] and only
/// its filename is recorded — bytes never reach Hive or a bloc state. See
/// `AvatarImageStore` for the two defects that rule prevents.
///
/// The LOCAL write happens even when the upload fails, and the failure is
/// swallowed rather than propagated. That is deliberate and mirrors
/// `SaveStoreLogoUseCase`: the user picked an image and pressed Save, so it
/// must appear on their device immediately. An empty `imageUrl` only means
/// other devices will not see it yet — and because the record is saved
/// `pendingUpdate`, the next sync cycle retries the whole row anyway.
class SaveProductImageUseCase {
  final ImageCompressionService _compressionService;
  final ProductImageStore _imageStore;
  final FirebaseStorageService _storageService;

  const SaveProductImageUseCase({
    required ImageCompressionService compressionService,
    required ProductImageStore imageStore,
    required FirebaseStorageService storageService,
  }) : this._(compressionService, imageStore, storageService);

  const SaveProductImageUseCase._(
    this._compressionService,
    this._imageStore,
    this._storageService,
  );

  /// [uid] is empty when the user is signed out — the photo is then kept
  /// locally only, with no upload attempted.
  Future<Product> call({
    required Product product,
    required Uint8List bytes,
    required String uid,
  }) async {
    final compressed = await _compressionService.compressToTargetSize(
      bytes,
      targetSizeKB: _kProductImageTargetKB,
      maxDimension: _kProductImageMaxDimension,
    );

    final filename = await _imageStore.save(
      productId: product.id,
      bytes: compressed,
    );
    final local = product.copyWith(imageFilename: filename);

    if (uid.isEmpty) return local;

    try {
      final url = await _storageService.uploadProductImage(
        uid: uid,
        productId: product.id,
        bytes: compressed,
      );
      return local.copyWith(imageUrl: url);
    } catch (_) {
      // Swallowed on purpose — see the class doc. The photo is already on
      // disk, and the record is written `pendingUpdate`, so the next sync
      // cycle retries the upload for this product.
      return local;
    }
  }
}

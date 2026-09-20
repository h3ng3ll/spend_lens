import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/product_image_store/product_image_store.dart';
import '../models/product/product.dart';

/// Clears a product's photo: the file on disk, the stored filename, and the
/// remote object plus its URL.
///
/// Returns the updated product so the caller saves ONE record carrying both
/// the cleared photo and any name edit made in the same session.
///
/// Unlike [SaveProductImageUseCase], a remote failure here is NOT swallowed:
/// an orphaned object the user believes is deleted is a privacy matter, not a
/// cosmetic one — the same reasoning as `RemoveStoreLogoUseCase`.
class RemoveProductImageUseCase {
  final ProductImageStore _imageStore;
  final FirebaseStorageService _storageService;

  const RemoveProductImageUseCase({
    required ProductImageStore imageStore,
    required FirebaseStorageService storageService,
  }) : this._(imageStore, storageService);

  const RemoveProductImageUseCase._(this._imageStore, this._storageService);

  /// [uid] is empty when the user is signed out — nothing was ever uploaded
  /// under a uid, so only the local file is removed.
  Future<Product> call({required Product product, required String uid}) async {
    // File first, then the pointer: a delete that fails after the filename is
    // cleared would leave the image on disk with nothing referencing it.
    await _imageStore.delete(product.imageFilename);

    if (uid.isNotEmpty) {
      await _storageService.deleteProductImage(
        uid: uid,
        productId: product.id,
      );
    }

    return product.copyWith(imageFilename: null, imageUrl: '');
  }
}

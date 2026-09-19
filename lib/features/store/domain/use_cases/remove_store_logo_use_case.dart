import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/store_logo_image_store/store_logo_image_store.dart';
import '../models/store/store.dart';

/// Clears a store's logo: the file on disk, the stored filename, and the
/// remote object plus its URL.
///
/// Returns the updated store so the caller saves ONE record carrying both the
/// cleared logo and any name edit made in the same session.
///
/// Unlike [SaveStoreLogoUseCase], a remote failure here is NOT swallowed: an
/// orphaned object the user believes is deleted is a privacy matter, not a
/// cosmetic one — the same reasoning as [RemoveAvatarUseCase].
class RemoveStoreLogoUseCase {
  final StoreLogoImageStore _imageStore;
  final FirebaseStorageService _storageService;

  const RemoveStoreLogoUseCase({
    required StoreLogoImageStore imageStore,
    required FirebaseStorageService storageService,
  }) : this._(imageStore, storageService);

  const RemoveStoreLogoUseCase._(this._imageStore, this._storageService);

  /// [uid] is empty when the user is signed out — nothing was ever uploaded
  /// under a uid, so only the local file is removed.
  Future<Store> call({required Store store, required String uid}) async {
    // File first, then the pointer: a delete that fails after the filename is
    // cleared would leave the image on disk with nothing referencing it.
    await _imageStore.delete(store.logoFilename);

    if (uid.isNotEmpty) {
      await _storageService.deleteStoreLogo(uid: uid, storeId: store.id);
    }

    return store.copyWith(logoFilename: null, logoUrl: '');
  }
}

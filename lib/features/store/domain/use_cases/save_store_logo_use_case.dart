import 'dart:typed_data';

import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/image_compression_service.dart';
import '../../../../core/services/store_logo_image_store/store_logo_image_store.dart';
import '../models/store/store.dart';

/// Logo budget. Matches the avatar's rather than the receipt's: a logo is
/// rendered at most at 96dp and is read on every store row, whereas a receipt
/// photo is opened deliberately and must stay legible enough to read.
const int _kStoreLogoTargetKB = 100;

/// Longer-edge bound for the stored logo.
///
/// The logo renders at 96dp at most, so 512px covers a 3x display with room to
/// spare. Bounding it is not only a size optimisation: without a resize,
/// quality is the compressor's only lever, so a full-resolution phone photo
/// runs every quality step, each decoding and re-encoding millions of pixels —
/// long enough for Android to raise an ANR and kill the app mid-save.
const int _kStoreLogoMaxDimension = 512;

/// Compresses a picked logo, commits it to disk for [store], and uploads it,
/// returning the store with `logoFilename` and `logoUrl` updated.
///
/// The compressed image is written to DISK via [StoreLogoImageStore] and only
/// its filename is recorded — bytes never reach Hive or a bloc state. See
/// `AvatarImageStore` for the two defects that rule prevents.
///
/// The LOCAL write happens even when the upload fails, and the failure is
/// swallowed rather than propagated. That is deliberate and mirrors
/// [UploadAvatarUseCase]: the user picked an image and pressed Save, so it
/// must appear on their device immediately. An empty `logoUrl` only means
/// other devices will not see it yet — and because the record is saved
/// `pendingUpdate`, the next sync cycle retries the whole row anyway.
class SaveStoreLogoUseCase {
  final ImageCompressionService _compressionService;
  final StoreLogoImageStore _imageStore;
  final FirebaseStorageService _storageService;

  const SaveStoreLogoUseCase({
    required ImageCompressionService compressionService,
    required StoreLogoImageStore imageStore,
    required FirebaseStorageService storageService,
  }) : this._(compressionService, imageStore, storageService);

  const SaveStoreLogoUseCase._(
    this._compressionService,
    this._imageStore,
    this._storageService,
  );

  /// [uid] is empty when the user is signed out — the logo is then kept
  /// locally only, with no upload attempted.
  Future<Store> call({
    required Store store,
    required Uint8List bytes,
    required String uid,
  }) async {
    final compressed = await _compressionService.compressToTargetSize(
      bytes,
      targetSizeKB: _kStoreLogoTargetKB,
      maxDimension: _kStoreLogoMaxDimension,
    );

    final filename = await _imageStore.save(
      storeId: store.id,
      bytes: compressed,
    );
    final local = store.copyWith(logoFilename: filename);

    if (uid.isEmpty) return local;

    try {
      final url = await _storageService.uploadStoreLogo(
        uid: uid,
        storeId: store.id,
        bytes: compressed,
      );
      return local.copyWith(logoUrl: url);
    } catch (_) {
      // Swallowed on purpose — see the class doc. The logo is already on
      // disk, and the record is written `pendingUpdate`, so the next sync
      // cycle retries the upload for this store.
      return local;
    }
  }
}

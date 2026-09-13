import 'dart:typed_data';

import '../../../../core/services/avatar_image_store/avatar_image_store.dart';
import '../../../../core/services/image_compression_service.dart';
import '../models/user_profile/user_profile.dart';
import '../repositories/i_user_profile_local_repository.dart';
import '../repositories/i_user_profile_remote_repository.dart';

/// Avatar budget. Far below the 200 KB receipt budget because an avatar is
/// rendered at most at 88dp and is fetched on every cold start, whereas a
/// receipt photo is opened deliberately and must stay legible enough to read.
const int _kAvatarTargetKB = 100;

/// Longer-edge bound for the stored avatar.
///
/// The avatar renders at 96dp at most, so 512px covers a 3x display with room
/// to spare. Bounding it is not only a size optimisation: without a resize,
/// quality is the compressor's only lever, so a full-resolution phone photo
/// runs every quality step, each decoding and re-encoding millions of pixels —
/// long enough for Android to raise an ANR and kill the app mid-save.
const int _kAvatarMaxDimension = 512;

/// Compresses, caches and uploads a new avatar, returning the profile with its
/// `photoUrl` updated.
///
/// The compressed image is written to DISK via [AvatarImageStore] and only its
/// filename is recorded — bytes never reach Hive or a bloc state. See
/// [AvatarImageStore] for the defects that rule prevents.
///
/// The LOCAL write happens even when the upload fails. That is deliberate: the
/// user picked an image and pressed Save, so it must appear on their device
/// immediately. A missing `photoUrl` only means other devices will not see it
/// yet.
class UploadAvatarUseCase {
  final IUserProfileLocalRepository _localRepository;
  final IUserProfileRemoteRepository _remoteRepository;
  final ImageCompressionService _compressionService;
  final AvatarImageStore _imageStore;

  const UploadAvatarUseCase({
    required IUserProfileLocalRepository localRepository,
    required IUserProfileRemoteRepository remoteRepository,
    required ImageCompressionService compressionService,
    required AvatarImageStore imageStore,
  }) : this._(
         localRepository,
         remoteRepository,
         compressionService,
         imageStore,
       );

  const UploadAvatarUseCase._(
    this._localRepository,
    this._remoteRepository,
    this._compressionService,
    this._imageStore,
  );

  Future<UserProfile> call({
    required UserProfile profile,
    required Uint8List bytes,
  }) async {
    final compressed = await _compressionService.compressToTargetSize(
      bytes,
      targetSizeKB: _kAvatarTargetKB,
      maxDimension: _kAvatarMaxDimension,
    );

    final filename = await _imageStore.save(compressed);
    await _localRepository.saveAvatarFilename(filename);

    if (profile.uid.isEmpty) return profile;

    final url = await _remoteRepository.uploadAvatar(
      uid: profile.uid,
      bytes: compressed,
    );
    return profile.copyWith(photoUrl: url);
  }
}

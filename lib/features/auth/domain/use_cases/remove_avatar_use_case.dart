import '../../../../core/services/avatar_image_store/avatar_image_store.dart';
import '../models/user_profile/user_profile.dart';
import '../repositories/i_user_profile_local_repository.dart';
import '../repositories/i_user_profile_remote_repository.dart';

/// Clears the avatar: the file on disk, the stored object, and `photoUrl`.
///
/// Returns the updated profile so the caller saves ONE record carrying both
/// the cleared photo and any name edit made in the same session.
///
/// The remote delete is attempted only when a uid exists; its failure
/// propagates, because an orphaned object that the user believes is deleted is
/// a privacy matter, not a cosmetic one.
class RemoveAvatarUseCase {
  final IUserProfileLocalRepository _localRepository;
  final IUserProfileRemoteRepository _remoteRepository;
  final AvatarImageStore _imageStore;

  const RemoveAvatarUseCase({
    required IUserProfileLocalRepository localRepository,
    required IUserProfileRemoteRepository remoteRepository,
    required AvatarImageStore imageStore,
  }) : this._(localRepository, remoteRepository, imageStore);

  const RemoveAvatarUseCase._(
    this._localRepository,
    this._remoteRepository,
    this._imageStore,
  );

  Future<UserProfile> call(UserProfile profile) async {
    // File first, then the pointer: a delete that fails after the filename is
    // cleared would leave the image on disk with nothing referencing it.
    await _imageStore.delete(await _localRepository.getAvatarFilename());
    await _localRepository.saveAvatarFilename(null);

    if (profile.uid.isNotEmpty) {
      await _remoteRepository.deleteAvatar(profile.uid);
    }

    return profile.copyWith(photoUrl: '');
  }
}

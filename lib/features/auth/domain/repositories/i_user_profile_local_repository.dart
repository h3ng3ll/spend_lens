import '../models/user_profile/user_profile.dart';

/// Local persistence for the signed-in user's profile.
///
/// The avatar is stored as a FILE on disk (see `AvatarImageStore`); this
/// repository keeps only its FILENAME, under its own key. Two reasons:
///
/// * **Photos do not belong in Hive or in a bloc state.** A `Uint8List` in a
///   freezed state forces `DeepCollectionEquality` into `==`/`hashCode` and
///   the raw bytes into `toString()` — measured at 36 ms / 32 ms / 309 ms for
///   a 12 MB image, which tombstoned the app when `AppObserver` logged it.
/// * The filename must survive a profile write that does not touch the photo,
///   and a name-only read must not drag an image along with it.
abstract interface class IUserProfileLocalRepository {
  static const String profileKey = 'user_profile';

  /// Holds the avatar's FILENAME — never its bytes.
  static const String avatarKey = 'user_avatar_filename';

  Future<UserProfile?> get();

  Stream<UserProfile?> watch();

  Future<void> save(UserProfile profile);

  /// The stored avatar's filename, or null when none is set.
  Future<String?> getAvatarFilename();

  Stream<String?> watchAvatarFilename();

  /// Pass null to forget the cached image.
  Future<void> saveAvatarFilename(String? filename);

  /// Drops BOTH the profile and the avatar filename. Called on sign-out so the
  /// next user on this device never sees the previous one's name or face.
  Future<void> clear();
}

import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../../../../core/hive/hive_database.dart';
import '../../domain/models/user_profile/user_profile.dart';
import '../../domain/repositories/i_user_profile_local_repository.dart';

/// The pre-filename key, which held the avatar's raw `Uint8List`.
///
/// Read once on write so an upgrading install does not strand a multi-megabyte
/// blob in Hive forever. The image itself is not migrated: it is re-read from
/// the server on next sync, or simply re-picked, and neither is worth carrying
/// migration code for a single cached thumbnail.
const String _kLegacyAvatarBytesKey = 'user_avatar';

/// Hive-backed [IUserProfileLocalRepository].
///
/// Box name is plural lowercase (`'profiles'`) per hive_rules.md §5, and the
/// box is NEVER cached — every operation opens it through [HiveDatabase],
/// which calls `Hive.openBox` directly. Hive de-duplicates opens, so this
/// costs nothing, and caching would break `box.watch()` (recorded global bug
/// `hive-getbox-cache-breaks-watch`).
///
/// The box is `dynamic`-typed because it holds two different value shapes: a
/// JSON String for the profile and a String filename for the avatar. The
/// profile is stored encoded rather than as a registered Hive object so this
/// feature adds no adapter and leaves the pinned typeId ranges untouched — see
/// [UserProfile]'s doc comment.
///
/// **The avatar's BYTES are not here.** They live on the filesystem via
/// `AvatarImageStore`; this box holds only the filename. See
/// [IUserProfileLocalRepository] for why.
class UserProfileLocalRepository implements IUserProfileLocalRepository {
  static const _boxName = 'profiles';

  final HiveDatabase _hiveDatabase;

  const UserProfileLocalRepository(this._hiveDatabase);

  Future<Box<dynamic>> get _box => _hiveDatabase.getBox<dynamic>(_boxName);

  /// Decodes the stored record, returning null when absent OR unreadable.
  ///
  /// A corrupt/legacy value must not throw: this is read on every Profile
  /// build, and a parse failure there would take down a screen the user can
  /// otherwise still use. Treating it as "no profile yet" degrades to the
  /// placeholder avatar, which is honest and recoverable by re-editing.
  UserProfile? _decode(Object? raw) {
    if (raw is! String || raw.isEmpty) return null;
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Reads the filename, tolerating the legacy `Uint8List` value.
  ///
  /// An upgrading install can still have bytes under the OLD key; this reads
  /// the NEW key only, so a legacy value is simply invisible (and is purged by
  /// [_purgeLegacyAvatarBytes] on the next write).
  String? _filename(Object? raw) =>
      raw is String && raw.isNotEmpty ? raw : null;

  @override
  Future<UserProfile?> get() async {
    final box = await _box;
    return _decode(box.get(IUserProfileLocalRepository.profileKey));
  }

  @override
  Stream<UserProfile?> watch() async* {
    final box = await _box;
    yield _decode(box.get(IUserProfileLocalRepository.profileKey));
    yield* box
        .watch(key: IUserProfileLocalRepository.profileKey)
        .map((_) => _decode(box.get(IUserProfileLocalRepository.profileKey)));
  }

  @override
  Future<void> save(UserProfile profile) async {
    final box = await _box;
    await box.put(
      IUserProfileLocalRepository.profileKey,
      jsonEncode(profile.toJson()),
    );
  }

  @override
  Future<String?> getAvatarFilename() async {
    final box = await _box;
    return _filename(box.get(IUserProfileLocalRepository.avatarKey));
  }

  @override
  Stream<String?> watchAvatarFilename() async* {
    final box = await _box;
    String? read() => _filename(box.get(IUserProfileLocalRepository.avatarKey));

    yield read();
    yield* box
        .watch(key: IUserProfileLocalRepository.avatarKey)
        .map((_) => read());
  }

  @override
  Future<void> saveAvatarFilename(String? filename) async {
    final box = await _box;
    await _purgeLegacyAvatarBytes(box);

    if (filename == null || filename.isEmpty) {
      await box.delete(IUserProfileLocalRepository.avatarKey);
      return;
    }
    await box.put(IUserProfileLocalRepository.avatarKey, filename);
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.deleteAll([
      IUserProfileLocalRepository.profileKey,
      IUserProfileLocalRepository.avatarKey,
      _kLegacyAvatarBytesKey,
    ]);
  }

  /// Drops the pre-filename `Uint8List` value if this install has one.
  ///
  /// Cheap and idempotent: after the first write the key is gone and
  /// `containsKey` is a map lookup.
  Future<void> _purgeLegacyAvatarBytes(Box<dynamic> box) async {
    if (box.containsKey(_kLegacyAvatarBytesKey)) {
      await box.delete(_kLegacyAvatarBytesKey);
    }
  }
}

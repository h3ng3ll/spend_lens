import 'dart:typed_data';

import '../../domain/models/user_profile/user_profile.dart';
import '../../domain/repositories/i_user_profile_remote_repository.dart';

/// No-op [IUserProfileRemoteRepository] for when Firebase is unavailable.
///
/// Mirrors `UnconfiguredAuthRepository` / `UnconfiguredSyncRepository`: a
/// missing backend is a DISABLED FEATURE with honest UI, never a thrown
/// exception. Every method succeeds vacuously, so a profile edit still saves
/// LOCALLY and the screen reports success — which is the truth, since the Hive
/// write is the half that actually happened.
class UnconfiguredUserProfileRepository
    implements IUserProfileRemoteRepository {
  const UnconfiguredUserProfileRepository();

  @override
  Future<UserProfile?> fetch(String uid) async => null;

  @override
  Future<void> save(UserProfile profile) async {}

  @override
  Future<String> uploadAvatar({
    required String uid,
    required Uint8List bytes,
  }) async => '';

  @override
  Future<void> deleteAvatar(String uid) async {}

  @override
  Future<void> deleteUserDocument(String uid) async {}
}

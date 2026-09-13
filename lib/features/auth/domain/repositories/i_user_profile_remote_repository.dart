import 'dart:typed_data';

import '../models/user_profile/user_profile.dart';

/// Remote mirror of the user's profile: the `/users/{uid}` Firestore document
/// and the avatar object in Storage.
///
/// Throws on failure rather than returning `Either` — the `Failure` boundary
/// lives in the use cases, matching [SyncFirestoreRepository]'s contract, so
/// error classification happens once where the decision is made.
abstract interface class IUserProfileRemoteRepository {
  Future<UserProfile?> fetch(String uid);

  /// Field-level MERGE, never a document replace — see
  /// `FirebaseFirestoreService.setUserDocument`.
  Future<void> save(UserProfile profile);

  /// Returns the download URL to store on the profile.
  Future<String> uploadAvatar({
    required String uid,
    required Uint8List bytes,
  });

  Future<void> deleteAvatar(String uid);

  /// Removes the `/users/{uid}` profile document itself.
  ///
  /// Separate from the record subcollections: deleting a Firestore document
  /// does NOT delete its subcollections, and deleting every subcollection does
  /// not delete the parent. Account deletion has to do both explicitly.
  Future<void> deleteUserDocument(String uid);
}

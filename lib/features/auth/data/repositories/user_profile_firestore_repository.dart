import 'dart:typed_data';

import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../domain/models/user_profile/user_profile.dart';
import '../../domain/repositories/i_user_profile_remote_repository.dart';

/// Firestore + Storage backed [IUserProfileRemoteRepository].
class UserProfileFirestoreRepository implements IUserProfileRemoteRepository {
  final FirebaseFirestoreService _firestoreService;
  final FirebaseStorageService _storageService;

  const UserProfileFirestoreRepository({
    required FirebaseFirestoreService firestoreService,
    required FirebaseStorageService storageService,
  }) : this._(firestoreService, storageService);

  const UserProfileFirestoreRepository._(
    this._firestoreService,
    this._storageService,
  );

  @override
  Future<UserProfile?> fetch(String uid) async {
    final data = await _firestoreService.fetchUserDocument(uid);
    if (data == null) return null;
    try {
      return UserProfile.fromJson(data);
    } catch (_) {
      // A document written by an older/newer shape must not crash sign-in.
      // Absence and unreadability both mean "nothing to seed from" here.
      return null;
    }
  }

  @override
  Future<void> save(UserProfile profile) =>
      _firestoreService.setUserDocument(profile.uid, profile.toJson());

  @override
  Future<String> uploadAvatar({
    required String uid,
    required Uint8List bytes,
  }) => _storageService.uploadAvatar(uid: uid, bytes: bytes);

  @override
  Future<void> deleteAvatar(String uid) =>
      _storageService.deleteAvatar(uid: uid);

  @override
  Future<void> deleteUserDocument(String uid) =>
      _firestoreService.deleteUserDocument(uid);
}

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/services/logger_service.dart';
import 'package:spend_lens/features/auth/domain/models/apple_credentials/apple_credentials.dart';
import 'package:spend_lens/features/auth/domain/models/user_profile/user_profile.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_local_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_remote_repository.dart';
import 'package:spend_lens/features/auth/domain/use_cases/save_user_profile_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/seed_profile_from_credentials_use_case.dart';

/// Apple returns `givenName`/`familyName` ONLY on the first authorization.
/// Every later sign-in sends nulls, permanently, unless the user revokes the
/// app in iOS Settings.
///
/// The shipped bug these cover: `AuthBloc` discarded the sign-in result with an
/// empty `fold` callback, so the one moment the name was obtainable was thrown
/// away and no amount of signing in again could recover it.
void main() {
  late _FakeLocal local;
  late _FakeRemote remote;
  late SeedProfileFromCredentialsUseCase seed;

  setUp(() {
    local = _FakeLocal();
    remote = _FakeRemote();
    final logger = LoggerService();
    seed = SeedProfileFromCredentialsUseCase(
      localRepository: local,
      remoteRepository: remote,
      saveUserProfile: SaveUserProfileUseCase(
        localRepository: local,
        remoteRepository: remote,
        loggerService: logger,
      ),
      loggerService: logger,
    );
  });

  test('the FIRST Apple authorization persists the name it hands over', () async {
    await seed(
      user: _FakeUser(uid: 'u1', email: 'a@b.c'),
      appleCredentials: const AppleCredentials(
        firstName: 'John',
        lastName: 'Appleseed',
        email: 'a@b.c',
      ),
    );

    expect(local.profile?.firstName, 'John');
    expect(local.profile?.lastName, 'Appleseed');
    expect(local.profile?.uid, 'u1');
  });

  test(
    'a LATER Apple sign-in sending nulls does not blank the stored name',
    () async {
      await seed(
        user: _FakeUser(uid: 'u1', email: 'a@b.c'),
        appleCredentials: const AppleCredentials(
          firstName: 'John',
          lastName: 'Appleseed',
        ),
      );

      // Second sign-in: Apple sends nothing. This is the regression.
      await seed(
        user: _FakeUser(uid: 'u1', email: 'a@b.c'),
        appleCredentials: const AppleCredentials(),
      );

      expect(local.profile?.firstName, 'John');
      expect(local.profile?.lastName, 'Appleseed');
    },
  );

  test('a name the user edited survives a later sign-in', () async {
    local.profile = const UserProfile(
      uid: 'u1',
      firstName: 'Edited',
      lastName: 'Name',
    );

    await seed(
      user: _FakeUser(uid: 'u1', email: 'a@b.c', displayName: 'Provider Name'),
      appleCredentials: const AppleCredentials(firstName: 'Apple'),
    );

    expect(local.profile?.firstName, 'Edited');
    expect(local.profile?.lastName, 'Name');
  });

  test('a Google display name seeds first/last when nothing is stored', () async {
    await seed(user: _FakeUser(uid: 'u2', displayName: 'Ada Lovelace'));

    expect(local.profile?.firstName, 'Ada');
    expect(local.profile?.lastName, 'Lovelace');
  });

  test('a different uid does not inherit the previous user profile', () async {
    local.profile = const UserProfile(uid: 'u1', firstName: 'Previous');

    await seed(user: _FakeUser(uid: 'u2', email: 'new@b.c'));

    expect(local.profile?.uid, 'u2');
    expect(local.profile?.firstName, isEmpty);
  });

  test('seeding never throws when the remote is unavailable', () async {
    remote.throwOnSave = true;

    await expectLater(
      seed(user: _FakeUser(uid: 'u1', email: 'a@b.c')),
      completes,
    );
  });
}

/// Stubs only the four `User` fields the use case reads; `noSuchMethod`
/// absorbs the rest of Firebase's large interface — the same shape
/// `auth_bloc_test.dart`'s `_StubUser` uses.
class _FakeUser implements User {
  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoURL = null;

  _FakeUser({required this.uid, this.email, this.displayName});

  @override
  List<UserInfo> get providerData => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeLocal implements IUserProfileLocalRepository {
  UserProfile? profile;
  Uint8List? avatar;

  @override
  Future<UserProfile?> get() async => profile;

  @override
  Stream<UserProfile?> watch() => Stream.value(profile);

  @override
  Future<void> save(UserProfile value) async => profile = value;

  @override
  Future<Uint8List?> getAvatarBytes() async => avatar;

  @override
  Stream<Uint8List?> watchAvatarBytes() => Stream.value(avatar);

  @override
  Future<void> saveAvatarBytes(Uint8List? bytes) async => avatar = bytes;

  @override
  Future<void> clear() async {
    profile = null;
    avatar = null;
  }
}

class _FakeRemote implements IUserProfileRemoteRepository {
  bool throwOnSave = false;
  UserProfile? remoteProfile;

  @override
  Future<UserProfile?> fetch(String uid) async => remoteProfile;

  @override
  Future<void> save(UserProfile profile) async {
    if (throwOnSave) throw Exception('offline');
  }

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

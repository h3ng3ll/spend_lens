import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:spend_lens/core/services/avatar_image_store/avatar_image_store.dart';

import 'package:spend_lens/core/services/image_compression_service.dart';
import 'package:spend_lens/core/services/logger_service.dart';
import 'package:spend_lens/features/auth/domain/models/user_profile/user_profile.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_local_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_remote_repository.dart';
import 'package:spend_lens/features/auth/domain/use_cases/remove_avatar_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/save_user_profile_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/upload_avatar_use_case.dart';
import 'package:spend_lens/features/auth/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';

/// `edit_profile_screen_rules.md` rule 3: remove is STAGED, never committed on
/// tap. Rule 2: the remove affordance appears only when an avatar exists.
void main() {
  late _FakeLocal local;
  late _FakeRemote remote;
  late Directory tempDir;
  const imageStore = AvatarImageStore();

  /// Drains the bloc's microtask + I/O queue.
  ///
  /// The avatar handlers await real filesystem work (staging a pick,
  /// discarding it), so a single `Duration.zero` no longer settles them — it
  /// yields once, while a copy takes several turns.
  ///
  /// The delay is non-zero DELIBERATELY. `Duration.zero` drains the microtask
  /// queue but does not let the event loop service real disk I/O, so the
  /// filesystem-backed tests (`picking after removing cancels the removal`,
  /// the upload-failure and save-progress cases) asserted against a bloc
  /// whose file copy had not landed yet, and failed.
  ///
  /// This used to read `await settle();` — a call to ITSELF, not a delay.
  /// That recursed 8-ways per level without a base case, allocating futures
  /// until the test process exhausted system memory (observed: a single
  /// `flutter_tester` at 9.2 GB) and never terminated, so `flutter test`
  /// could not complete a run at all.
  Future<void> settle() async {
    for (var i = 0; i < 8; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  /// A picked file the bloc can stage from — the picker hands back a path, so
  /// the tests do too.
  Future<String> pickedFile([List<int> bytes = const [1, 2, 3]]) async {
    final file = File('${tempDir.path}/picked_${bytes.hashCode}.jpg');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  EditProfileBloc build() => EditProfileBloc(
    localRepository: local,
    saveUserProfile: SaveUserProfileUseCase(
      localRepository: local,
      remoteRepository: remote,
      loggerService: LoggerService(),
    ),
    uploadAvatar: UploadAvatarUseCase(
      localRepository: local,
      remoteRepository: remote,
      compressionService: const ImageCompressionService(),
      imageStore: imageStore,
    ),
    removeAvatar: RemoveAvatarUseCase(
      localRepository: local,
      remoteRepository: remote,
      imageStore: imageStore,
    ),
    imageStore: imageStore,
  );

  setUpAll(() {
    // `AvatarImageStore` does real file I/O, which is the point: the avatar
    // lives on disk, not in Hive or a state.
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('avatar_store_test');
    PathProviderPlatform.instance = _FakePathProvider(tempDir.path);
    local = _FakeLocal();
    remote = _FakeRemote();
    local.profile = const UserProfile(uid: 'u1', firstName: 'John');
    local.avatar = 'avatar.jpg';
  });

  test('tapping remove does NOT delete anything until save', () async {
    final bloc = build();
    bloc.add(const EditProfileEvent.started());
    await settle();

    bloc.add(const EditProfileEvent.avatarRemoved());
    await settle();

    // Staged only: the stored bytes and the remote object are untouched.
    expect(bloc.state.avatarRemoved, isTrue);
    expect(bloc.state.hasAvatar, isFalse);
    expect(local.avatar, isNotNull, reason: 'remove must not commit on tap');
    expect(remote.deletedUid, isNull);

    await bloc.close();
  });

  test('save commits the staged removal', () async {
    final bloc = build();
    bloc.add(const EditProfileEvent.started());
    await settle();

    bloc.add(const EditProfileEvent.avatarRemoved());
    await settle();
    bloc.add(const EditProfileEvent.save());
    await settle();

    expect(local.avatar, isNull);
    expect(remote.deletedUid, 'u1');
    expect(local.profile?.photoUrl, isEmpty);

    await bloc.close();
  });

  test('the remove affordance is gated on an avatar existing', () async {
    local.avatar = null;
    final bloc = build();
    bloc.add(const EditProfileEvent.started());
    await settle();

    expect(bloc.state.hasAvatar, isFalse);

    await bloc.close();
  });

  test('picking after removing cancels the removal', () async {
    final bloc = build();
    bloc.add(const EditProfileEvent.started());
    await settle();

    bloc.add(const EditProfileEvent.avatarRemoved());
    await settle();
    bloc.add(EditProfileEvent.avatarPicked(await pickedFile([9, 9])));
    await settle();

    expect(bloc.state.avatarRemoved, isFalse);
    expect(bloc.state.hasAvatar, isTrue);

    await bloc.close();
  });

  test('canSave is false until something actually changes', () async {
    final bloc = build();
    bloc.add(const EditProfileEvent.started());
    await settle();

    expect(bloc.state.canSave, isFalse);

    bloc.add(const EditProfileEvent.firstNameChanged('Jane'));
    await settle();

    expect(bloc.state.canSave, isTrue);

    await bloc.close();
  });

  group('the live identity fills gaps in the stored profile', () {
    test(
      'an email-less stored profile still shows the account email',
      () async {
        // The shipped bug: Profile read the email from AuthState (live), while
        // Edit Profile read it from the stored UserProfile. A user already
        // signed in when the feature shipped had no stored profile, so the
        // address appeared on one screen and the field was blank on the next.
        local.profile = const UserProfile(uid: 'u1');

        final bloc = build();
        bloc.add(const EditProfileEvent.started(uid: 'u1', email: 'live@b.c'));
        await settle();

        expect(bloc.state.email, 'live@b.c');

        await bloc.close();
      },
    );

    test('no stored profile at all still shows the account email', () async {
      local.profile = null;

      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1', email: 'live@b.c'));
      await settle();

      expect(bloc.state.email, 'live@b.c');
      expect(bloc.state.profile.uid, 'u1', reason: 'save needs a uid');

      await bloc.close();
    });

    test('a stored value is never overwritten by the live one', () async {
      local.profile = const UserProfile(
        uid: 'u1',
        email: 'stored@b.c',
        firstName: 'Stored',
      );

      final bloc = build();
      bloc.add(
        const EditProfileEvent.started(
          uid: 'u1',
          email: 'live@b.c',
          firstName: 'Live',
        ),
      );
      await settle();

      expect(bloc.state.email, 'stored@b.c');
      expect(bloc.state.firstName, 'Stored');

      await bloc.close();
    });
  });

  group('a failed avatar upload', () {
    test('does not discard the name edit', () async {
      // The name is local-only and has nothing to do with Storage. Losing it
      // because a photo server was unreachable makes the user retype an edit
      // that would otherwise have succeeded.
      remote.failUpload = true;

      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      bloc.add(const EditProfileEvent.firstNameChanged('Jane'));
      bloc.add(EditProfileEvent.avatarPicked(await pickedFile([1, 2])));
      await settle();
      bloc.add(const EditProfileEvent.save());
      await settle();

      expect(local.profile?.firstName, 'Jane');

      await bloc.close();
    });

    test('is still reported as failed, not silent success', () async {
      // The toast is the only signal the user gets; claiming success while the
      // photo did not upload is the worse lie.
      remote.failUpload = true;

      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      bloc.add(EditProfileEvent.avatarPicked(await pickedFile([1, 2])));
      await settle();
      bloc.add(const EditProfileEvent.save());
      await settle();

      expect(bloc.state.isFailed, isTrue);

      await bloc.close();
    });
  });

  group('photo pick progress', () {
    test('picking is flagged from the moment it starts', () async {
      // Covers the OS picker plus `readAsBytes` on a multi-megabyte photo.
      // Before this the avatar sat unchanged with no feedback the whole time,
      // which reads as a tap that did nothing.
      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      bloc.add(const EditProfileEvent.photoPickStarted());
      await settle();

      expect(bloc.state.isPickingPhoto, isTrue);
      expect(bloc.state.isAvatarBusy, isTrue);

      await bloc.close();
    });

    test('a cancelled pick clears the flag', () async {
      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      bloc.add(const EditProfileEvent.photoPickStarted());
      bloc.add(const EditProfileEvent.photoPickEnded());
      await settle();

      expect(bloc.state.isPickingPhoto, isFalse);

      await bloc.close();
    });

    test('bytes arriving ends the pick', () async {
      // The bytes ARE the end of the pick; without clearing here the spinner
      // would keep running over an image already on screen.
      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      bloc.add(const EditProfileEvent.photoPickStarted());
      bloc.add(EditProfileEvent.avatarPicked(await pickedFile([1, 2])));
      await settle();

      expect(bloc.state.isPickingPhoto, isFalse);
      expect(bloc.state.hasAvatar, isTrue);

      await bloc.close();
    });

    test('save is blocked while a pick is in flight', () async {
      // A save started mid-pick would commit the OLD avatar and race the
      // incoming bytes against a write already running.
      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      bloc.add(const EditProfileEvent.firstNameChanged('Jane'));
      await settle();
      expect(bloc.state.canSave, isTrue);

      bloc.add(const EditProfileEvent.photoPickStarted());
      await settle();
      expect(bloc.state.canSave, isFalse);

      await bloc.close();
    });
  });

  group('save progress', () {
    test('the photo phase is flagged so the UI can report it', () async {
      // Uploading is the slow, network-bound part. Without a distinct flag the
      // button could only say "saving", and the screen looked frozen long
      // enough for a user to tap again or back out mid-upload.
      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      final seen = <bool>[];
      final sub = bloc.stream.listen((s) => seen.add(s.isUploadingPhoto));

      bloc.add(EditProfileEvent.avatarPicked(await pickedFile([1, 2])));
      await settle();
      bloc.add(const EditProfileEvent.save());
      await settle();

      expect(seen, contains(true), reason: 'the upload phase must be visible');
      expect(
        bloc.state.isUploadingPhoto,
        isFalse,
        reason: 'the flag must clear once the save settles',
      );

      await sub.cancel();
      await bloc.close();
    });

    test('the flag clears even when the upload fails', () async {
      // A stuck flag would leave the button spinning forever on a screen the
      // user can no longer leave.
      remote.failUpload = true;

      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      bloc.add(EditProfileEvent.avatarPicked(await pickedFile([1, 2])));
      await settle();
      bloc.add(const EditProfileEvent.save());
      await settle();

      expect(bloc.state.isUploadingPhoto, isFalse);
      expect(bloc.state.isSaving, isFalse);

      await bloc.close();
    });

    test('a name-only save does not claim to be uploading a photo', () async {
      final bloc = build();
      bloc.add(const EditProfileEvent.started(uid: 'u1'));
      await settle();

      final seen = <bool>[];
      final sub = bloc.stream.listen((s) => seen.add(s.isUploadingPhoto));

      bloc.add(const EditProfileEvent.firstNameChanged('Jane'));
      await settle();
      bloc.add(const EditProfileEvent.save());
      await settle();

      expect(seen, everyElement(isFalse));

      await sub.cancel();
      await bloc.close();
    });
  });

  test('save persists the edited name', () async {
    final bloc = build();
    bloc.add(const EditProfileEvent.started());
    await settle();

    bloc.add(const EditProfileEvent.firstNameChanged('  Jane  '));
    bloc.add(const EditProfileEvent.lastNameChanged('Doe'));
    await settle();
    bloc.add(const EditProfileEvent.save());
    await settle();

    expect(bloc.state.isSaved, isTrue);
    expect(local.profile?.firstName, 'Jane', reason: 'must be trimmed');
    expect(local.profile?.lastName, 'Doe');

    await bloc.close();
  });
}

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  final String root;

  _FakePathProvider(this.root);

  @override
  Future<String?> getApplicationDocumentsPath() async => root;
}

class _FakeLocal implements IUserProfileLocalRepository {
  UserProfile? profile;

  /// The stored avatar's FILENAME — never its bytes, mirroring the real
  /// repository.
  String? avatar;

  @override
  Future<UserProfile?> get() async => profile;

  @override
  Stream<UserProfile?> watch() => Stream.value(profile);

  @override
  Future<void> save(UserProfile value) async => profile = value;

  @override
  Future<String?> getAvatarFilename() async => avatar;

  @override
  Stream<String?> watchAvatarFilename() => Stream.value(avatar);

  @override
  Future<void> saveAvatarFilename(String? filename) async => avatar = filename;

  @override
  Future<void> clear() async {
    profile = null;
    avatar = null;
  }
}

class _FakeRemote implements IUserProfileRemoteRepository {
  String? deletedUid;

  /// Simulates the Storage `403 Permission denied` seen on a bucket whose
  /// rules do not cover the avatar path.
  bool failUpload = false;

  @override
  Future<UserProfile?> fetch(String uid) async => null;

  @override
  Future<void> save(UserProfile profile) async {}

  @override
  Future<String> uploadAvatar({
    required String uid,
    required Uint8List bytes,
  }) async {
    if (failUpload) throw Exception('403 Permission denied');
    return 'https://example.test/avatar.jpg';
  }

  @override
  Future<void> deleteAvatar(String uid) async => deletedUid = uid;

  @override
  Future<void> deleteUserDocument(String uid) async {}
}

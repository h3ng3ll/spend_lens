import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/failures/failure.dart';
import 'package:spend_lens/features/auth/domain/models/apple_sign_in_result/apple_sign_in_result.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:spend_lens/features/auth/domain/use_cases/apple_sign_in_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:spend_lens/features/auth/domain/models/user_profile/user_profile.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_local_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_remote_repository.dart';
import 'package:spend_lens/features/auth/domain/use_cases/save_user_profile_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/seed_profile_from_credentials_use_case.dart';
import 'package:spend_lens/features/auth/domain/models/e_account_deletion_scope.dart';
import 'package:spend_lens/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/watch_user_profile_use_case.dart';
import 'package:spend_lens/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:spend_lens/features/sync/domain/use_cases/clear_synced_local_records_use_case.dart';
import 'package:spend_lens/core/services/firebase/firebase_firestore_service.dart';
import 'package:spend_lens/core/services/logger_service.dart';
import 'package:spend_lens/core/services/receipt_image_store/receipt_image_store.dart';
import 'package:spend_lens/features/receipt/domain/repositories/i_receipt_local_repository.dart';
import 'package:spend_lens/features/settings/domain/repositories/i_settings_local_repository.dart';
import 'package:spend_lens/features/sync/domain/adapters/sync_entity_adapters.dart';
import 'package:spend_lens/features/sync/domain/use_cases/run_full_sync_use_case.dart';

/// Sign-in concurrency. Both cases here shipped and were reproduced on a
/// device: a redundant tap turned a WORKING session into "Google sign-in
/// failed.", and the message then stuck to every later attempt.
void main() {
  late _FakeAuthRepository repository;
  late _FakeProfileLocalRepository profileLocalRepository;

  AuthBloc buildBloc() {
    const remote = _FakeProfileRemoteRepository();
    final loggerService = LoggerService();
    return AuthBloc(
      authRepository: repository,
      googleSignInUseCase: GoogleSignInUseCase(repository),
      appleSignInUseCase: AppleSignInUseCase(repository),
      signOutUseCase: SignOutUseCase(repository),
      clearSyncedLocalRecords: _NoopClear(),
      deleteAccountUseCase: _NoopDeleteAccount(),
      seedProfileFromCredentials: SeedProfileFromCredentialsUseCase(
        localRepository: profileLocalRepository,
        remoteRepository: remote,
        saveUserProfile: SaveUserProfileUseCase(
          localRepository: profileLocalRepository,
          remoteRepository: remote,
          loggerService: loggerService,
        ),
        loggerService: loggerService,
      ),
      watchUserProfile: WatchUserProfileUseCase(profileLocalRepository),
      userProfileLocalRepository: profileLocalRepository,
    );
  }

  setUp(() {
    repository = _FakeAuthRepository();
    profileLocalRepository = _FakeProfileLocalRepository();
  });

  group('a sign-in tap while already signed in', () {
    blocTest<AuthBloc, AuthState>(
      'is ignored, so a redundant cancel cannot fail a live session',
      setUp: () {
        repository.signedIn = true;
        // A second sheet for an account already signed in is cancelled by
        // the platform — the exact `[16] Cancelled by user.` from the logs.
        repository.googleResult = left(const _CanceledFailure());
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.signInGoogle()),
      expect: () => const <AuthState>[],
    );

    blocTest<AuthBloc, AuthState>(
      'applies to Apple too',
      setUp: () {
        repository.signedIn = true;
        repository.appleResult = left(const _CanceledFailure());
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.signInApple()),
      expect: () => const <AuthState>[],
    );
  });

  group('a stale failure message', () {
    blocTest<AuthBloc, AuthState>(
      'is cleared when a new attempt starts',
      // Otherwise `copyWith(status: signingIn)` carries it forward and
      // Profile re-toasts "Google sign-in failed." over a successful sign-in.
      seed: () => const AuthState(
        status: EAuthStatus.failed,
        errorMessage: 'Google sign-in failed.',
      ),
      setUp: () => repository.googleResult = left(const _CanceledFailure()),
      build: buildBloc,
      act: (bloc) => bloc.add(const AuthEvent.signInGoogle()),
      expect: () => [
        // The FIRST emission must already be clean.
        isA<AuthState>()
            .having((s) => s.status, 'status', EAuthStatus.signingIn)
            .having((s) => s.errorMessage, 'errorMessage', ''),
        // A user cancellation stays quiet (empty message), by design.
        isA<AuthState>().having((s) => s.errorMessage, 'errorMessage', ''),
      ],
    );
  });
  group('a session restored at launch', () {
    // THE BUG THIS FIXES: seeding ran only inside the sign-in handlers, so a
    // user already signed in when the profile feature shipped never had one
    // written. Profile showed their email (read live from AuthState) while
    // Edit Profile showed a blank field (read from the absent stored profile).
    test('seeds the profile without any sign-in tap', () async {
      final user = _RestoredUser(uid: 'u1', email: 'restored@b.c');
      repository.userStream = Stream.value(user);
      repository.restoredUser = user;

      final bloc = buildBloc();
      bloc.add(const AuthEvent.watch());
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(profileLocalRepository.profile, isNotNull);
      expect(profileLocalRepository.profile?.email, 'restored@b.c');
      expect(profileLocalRepository.profile?.uid, 'u1');

      await bloc.close();
    });
  });

}

class _CanceledFailure extends Failure {
  const _CanceledFailure() : super('');
}

class _FakeAuthRepository implements IAuthRepository {
  bool signedIn = false;
  Either<Failure, UserCredential>? googleResult;
  Either<Failure, AppleSignInResult>? appleResult;

  /// Set alongside `userStream` when a test simulates a restored session: the
  /// seed handler re-reads the user from here rather than off the event, to
  /// keep the email out of `AppObserver`'s logs.
  User? restoredUser;

  @override
  User? get currentUser => restoredUser ?? (signedIn ? _StubUser() : null);

  /// Emits whatever `userStream` is set to, so a test can simulate a session
  /// RESTORED at launch — the path that never passes through a sign-in handler.
  Stream<User?>? userStream;

  @override
  Stream<User?> watchUser() => userStream ?? const Stream<User?>.empty();

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async =>
      googleResult ?? left(const _CanceledFailure());

  @override
  Future<Either<Failure, AppleSignInResult>> signInWithApple() async =>
      appleResult ?? left(const _CanceledFailure());

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubUser implements User {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Sign-out cleanup is not exercised by these cases, and building the real
/// use case would need six unrelated collaborators. Subclassing overrides the
/// only method the bloc calls; the super-constructor arguments are typed
/// stubs that are never dereferenced.
/// Overridden `call()` means the real deletion pipeline is never entered here.
/// Account deletion has its own suite — `delete_account_use_case_test.dart` —
/// where the ordering guarantees are what is actually under test.
class _NoopDeleteAccount implements DeleteAccountUseCase {
  @override
  Future<Either<Failure, Unit>> call({
    required EAccountDeletionScope scope,
  }) async => const Right(unit);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopClear extends ClearSyncedLocalRecordsUseCase {
  _NoopClear()
    : super(
        receiptLocalRepository: _ReceiptsStub(),
        adapters: _AdaptersStub(),
        settingsLocalRepository: _SettingsStub(),
        imageStore: _ImageStoreStub(),
        runFullSync: _FullSyncStub(),
        firestoreService: _FirestoreStub(),
        loggerService: _LoggerStub(),
      );

  @override
  Future<int> call() async => 0;
}

/// One stub per collaborator. They cannot be merged into a single class —
/// `IReceiptLocalRepository`, `ISettingsLocalRepository` and
/// `ReceiptImageStore` each declare a `save` with an incompatible signature.
/// `call()` above guarantees no member of any of these is ever reached.
class _ReceiptsStub implements IReceiptLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SettingsStub implements ISettingsLocalRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AdaptersStub implements SyncEntityAdapters {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ImageStoreStub implements ReceiptImageStore {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FullSyncStub implements RunFullSyncUseCase {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FirestoreStub implements FirebaseFirestoreService {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _LoggerStub implements LoggerService {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// In-memory [IUserProfileLocalRepository]. The profile slice is incidental to
/// these sign-in concurrency cases — it only has to exist and not touch Hive.
class _FakeProfileLocalRepository implements IUserProfileLocalRepository {
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

class _FakeProfileRemoteRepository implements IUserProfileRemoteRepository {
  const _FakeProfileRemoteRepository();

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

/// A restored Firebase session. Unlike `_StubUser`, this one carries real
/// field values, because the seeding path actually reads them.
class _RestoredUser implements User {
  @override
  final String uid;
  @override
  final String? email;

  _RestoredUser({required this.uid, this.email});

  @override
  String? get displayName => null;

  @override
  String? get photoURL => null;

  @override
  List<UserInfo> get providerData => const [];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

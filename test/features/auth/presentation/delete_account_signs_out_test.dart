import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/failures/failure.dart';
import 'package:spend_lens/core/services/logger_service.dart';
import 'package:spend_lens/features/auth/domain/failures/auth_failures.dart';
import 'package:spend_lens/features/auth/domain/models/e_account_deletion_scope.dart';
import 'package:spend_lens/features/auth/domain/models/user_profile/user_profile.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_local_repository.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_user_profile_remote_repository.dart';
import 'package:spend_lens/features/auth/domain/use_cases/apple_sign_in_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/save_user_profile_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/seed_profile_from_credentials_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/watch_user_profile_use_case.dart';
import 'package:spend_lens/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:spend_lens/features/sync/domain/use_cases/clear_synced_local_records_use_case.dart';

/// A deletion that does NOT complete must not leave the user authorized.
///
/// The reported flow: Profile -> Delete account -> "Delete everywhere" ->
/// confirm -> a Google account chooser appears -> dismissed by tapping
/// outside -> the app shows nothing and is still signed in.
///
/// The chooser itself is fixed in the repository (it was a sign-in posing as
/// a re-authentication). This covers the second half: the user confirmed an
/// irreversible action, so the resting state afterwards cannot be a live
/// session. The account still exists and nothing was destroyed — but they are
/// signed out, which is both honest and observable.
void main() {
  late _RecordingAuthRepository repository;
  late _FakeProfileLocalRepository profileLocal;

  AuthBloc buildBloc(DeleteAccountUseCase deleteAccount) {
    const remote = _FakeProfileRemoteRepository();
    final loggerService = LoggerService();
    return AuthBloc(
      authRepository: repository,
      googleSignInUseCase: GoogleSignInUseCase(repository),
      appleSignInUseCase: AppleSignInUseCase(repository),
      signOutUseCase: SignOutUseCase(repository),
      clearSyncedLocalRecords: _NoopClear(),
      deleteAccountUseCase: deleteAccount,
      seedProfileFromCredentials: SeedProfileFromCredentialsUseCase(
        localRepository: profileLocal,
        remoteRepository: remote,
        saveUserProfile: SaveUserProfileUseCase(
          localRepository: profileLocal,
          remoteRepository: remote,
          loggerService: loggerService,
        ),
        loggerService: loggerService,
      ),
      watchUserProfile: WatchUserProfileUseCase(profileLocal),
      userProfileLocalRepository: profileLocal,
    );
  }

  setUp(() {
    repository = _RecordingAuthRepository();
    profileLocal = _FakeProfileLocalRepository();
  });

  blocTest<AuthBloc, AuthState>(
    'a CANCELLED deletion signs out instead of staying authorized',
    build: () => buildBloc(
      _StubDeleteAccount(
        const Left(AccountDeletionCanceledFailure(diagnostic: 'canceled')),
      ),
    ),
    act: (bloc) => bloc.add(
      const AuthEvent.deleteAccount(EAccountDeletionScope.everywhere),
    ),
    verify: (_) => expect(
      repository.signOutCount,
      1,
      reason: 'THE BUG: dismissing the sheet left the user signed in with no '
          'feedback at all, so nothing appeared to have happened',
    ),
  );

  blocTest<AuthBloc, AuthState>(
    'the cancelled case ends signedOut, never signedIn',
    build: () => buildBloc(
      _StubDeleteAccount(
        const Left(AccountDeletionCanceledFailure(diagnostic: 'canceled')),
      ),
    ),
    act: (bloc) => bloc.add(
      const AuthEvent.deleteAccount(EAccountDeletionScope.everywhere),
    ),
    verify: (bloc) {
      expect(bloc.state.status, EAuthStatus.signedOut);
      // Cancelling is the user's own choice, so it still raises no error.
      expect(bloc.state.errorMessage, isEmpty);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'a FAILED deletion signs out and reports the failure',
    build: () => buildBloc(
      _StubDeleteAccount(
        const Left(AccountDeletionFailure(diagnostic: 'network')),
      ),
    ),
    act: (bloc) => bloc.add(
      const AuthEvent.deleteAccount(EAccountDeletionScope.everywhere),
    ),
    verify: (bloc) {
      expect(repository.signOutCount, 1);
      expect(bloc.state.status, EAuthStatus.signedOut);
      expect(bloc.state.errorMessage, isNotEmpty);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'a SUCCESSFUL deletion still reports deleted, and signs out nothing',
    build: () => buildBloc(_StubDeleteAccount(const Right(unit))),
    act: (bloc) => bloc.add(
      const AuthEvent.deleteAccount(EAccountDeletionScope.everywhere),
    ),
    verify: (bloc) {
      expect(bloc.state.status, EAuthStatus.deleted);
      // `deleteAccount()` already ends the session and revokes the Google
      // grant; an extra sign-out here would be redundant.
      expect(repository.signOutCount, 0);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'no sign-out is attempted when the session is already gone',
    build: () {
      repository.signedIn = false;
      return buildBloc(
        _StubDeleteAccount(
          const Left(AccountDeletionFailure(diagnostic: 'half-deleted')),
        ),
      );
    },
    act: (bloc) => bloc.add(
      const AuthEvent.deleteAccount(EAccountDeletionScope.everywhere),
    ),
    verify: (bloc) {
      expect(repository.signOutCount, 0);
      expect(bloc.state.status, EAuthStatus.signedOut);
    },
  );
}

class _StubDeleteAccount implements DeleteAccountUseCase {
  final Either<Failure, Unit> result;

  const _StubDeleteAccount(this.result);

  @override
  Future<Either<Failure, Unit>> call({
    required EAccountDeletionScope scope,
  }) async => result;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingAuthRepository implements IAuthRepository {
  int signOutCount = 0;
  bool signedIn = true;

  @override
  Stream<User?> watchUser() => const Stream<User?>.empty();

  // Unfakeable Firebase type; the bloc's delete path reads the session
  // through this only to decide whether a sign-out is still needed.
  @override
  Null get currentUser => signedIn ? _throwUnfakeable() : null;

  @override
  String? get currentUid => signedIn ? 'user-a' : null;

  @override
  Future<void> signOut() async {
    signOutCount++;
    signedIn = false;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Never _throwUnfakeable() =>
    throw UnsupportedError('currentUser must not be read on this path');

class _FakeProfileLocalRepository implements IUserProfileLocalRepository {
  @override
  Future<UserProfile?> get() async => null;

  @override
  Stream<UserProfile?> watch() => const Stream<UserProfile?>.empty();

  @override
  Future<String?> getAvatarFilename() async => null;

  @override
  Future<void> saveAvatarFilename(String? filename) async {}

  @override
  Stream<String?> watchAvatarFilename() => const Stream<String?>.empty();

  @override
  Future<void> save(UserProfile profile) async {}

  @override
  Future<void> clear() async {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProfileRemoteRepository implements IUserProfileRemoteRepository {
  const _FakeProfileRemoteRepository();

  @override
  Future<UserProfile?> fetch(String uid) async => null;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopClear implements ClearSyncedLocalRecordsUseCase {
  @override
  Future<int> call() async => 0;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

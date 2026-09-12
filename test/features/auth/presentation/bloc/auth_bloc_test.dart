import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/failures/failure.dart';
import 'package:spend_lens/features/auth/domain/models/apple_sign_in_result/apple_sign_in_result.dart';
import 'package:spend_lens/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:spend_lens/features/auth/domain/use_cases/apple_sign_in_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:spend_lens/features/auth/domain/use_cases/sign_out_use_case.dart';
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

  AuthBloc buildBloc() => AuthBloc(
    authRepository: repository,
    googleSignInUseCase: GoogleSignInUseCase(repository),
    appleSignInUseCase: AppleSignInUseCase(repository),
    signOutUseCase: SignOutUseCase(repository),
    clearSyncedLocalRecords: _NoopClear(),
  );

  setUp(() => repository = _FakeAuthRepository());

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
}

class _CanceledFailure extends Failure {
  const _CanceledFailure() : super('');
}

class _FakeAuthRepository implements IAuthRepository {
  bool signedIn = false;
  Either<Failure, UserCredential>? googleResult;
  Either<Failure, AppleSignInResult>? appleResult;

  @override
  User? get currentUser => signedIn ? _StubUser() : null;

  @override
  Stream<User?> watchUser() => const Stream<User?>.empty();

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

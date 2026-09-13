import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failures/failure.dart';
import '../../domain/failures/auth_failures.dart';
import '../../domain/models/apple_sign_in_result/apple_sign_in_result.dart';
import '../../domain/repositories/i_auth_repository.dart';

/// [IAuthRepository] used when Firebase failed to initialize (no
/// `GoogleService-Info.plist` / `google-services.json` bundled yet —
/// design_spendlens.md §9/§12).
///
/// Always reports signed-out and every sign-in attempt as
/// [AuthUnavailableFailure] — an honest "not configured" outcome, never a
/// crash and never a generic error state. This is what keeps the app fully
/// functional anonymously (spec §8) regardless of whether Firebase
/// credentials exist yet.
class UnconfiguredAuthRepository implements IAuthRepository {
  /// Why auth is unavailable — the captured `Firebase.initializeApp()`
  /// error. Surfaced to the user so an unconfigured build explains itself
  /// instead of presenting buttons that appear to do nothing.
  final String reason;

  const UnconfiguredAuthRepository({this.reason = ''});

  @override
  Stream<User?> watchUser() => Stream.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async =>
      Left(AuthUnavailableFailure(diagnostic: reason));

  @override
  Future<Either<Failure, AppleSignInResult>> signInWithApple() async =>
      Left(AuthUnavailableFailure(diagnostic: reason));

  @override
  Future<void> signOut() async {}

  /// Succeeds vacuously: with no Firebase there is no account to delete, so
  /// the caller's goal already holds. Reporting a failure would block the
  /// local-data wipe that the delete flow performs alongside this.
  @override
  Future<Either<Failure, Unit>> deleteAccount() async => const Right(unit);

  @override
  Future<Either<Failure, Unit>> reauthenticate() async => const Right(unit);
}

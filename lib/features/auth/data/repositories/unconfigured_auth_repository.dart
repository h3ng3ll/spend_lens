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
  const UnconfiguredAuthRepository();

  @override
  Stream<User?> watchUser() => Stream.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<Either<UserCredential, Failure>> signInWithGoogle() async =>
      const Right(AuthUnavailableFailure());

  @override
  Future<Either<AppleSignInResult, Failure>> signInWithApple() async =>
      const Right(AuthUnavailableFailure());

  @override
  Future<void> signOut() async {}
}

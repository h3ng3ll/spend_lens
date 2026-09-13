import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failures/failure.dart';
import '../models/apple_sign_in_result/apple_sign_in_result.dart';

/// Auth contract (design_spendlens.md §9).
///
/// **Bug 5 fixed here.** The reference template misspelled this directory
/// `domain/repostories/` — this project uses the correct `domain/
/// repositories/` throughout (matching every other feature slice).
///
/// Every method returns [Failure] on the error side — never a second
/// `Exceptions` hierarchy (bug 4).
///
/// **Side order is `Either<Failure, T>`** — the conventional functional
/// ordering: Left = failure, Right = success ("right is right"). The earlier
/// `Either<T, Failure>` inverted that, so `fold`'s first callback was the
/// SUCCESS path — the opposite of every reader's expectation and an easy way
/// to silently handle the wrong branch.
abstract interface class IAuthRepository {
  Stream<User?> watchUser();

  User? get currentUser;

  Future<Either<Failure, UserCredential>> signInWithGoogle();

  Future<Either<Failure, AppleSignInResult>> signInWithApple();

  Future<void> signOut();

  /// Permanently deletes the Firebase user.
  ///
  /// Apple Guideline 5.1.1(v) requires an in-app path to this for any app that
  /// offers account creation.
  ///
  /// Firebase treats this as a security-critical operation and rejects it with
  /// `requires-recent-login` unless the user authenticated recently — which is
  /// the NORMAL case, since a session stays valid indefinitely while the last
  /// authentication ages out in minutes. [reauthenticate] exists to clear that,
  /// and the delete use case retries through it rather than surfacing an error
  /// the user cannot act on.
  Future<Either<Failure, Unit>> deleteAccount();

  /// Re-runs the provider sign-in for the CURRENT user, refreshing the
  /// credential age so [deleteAccount] can proceed.
  Future<Either<Failure, Unit>> reauthenticate();
}

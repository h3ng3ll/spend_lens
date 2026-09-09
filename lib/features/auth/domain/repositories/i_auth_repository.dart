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
}

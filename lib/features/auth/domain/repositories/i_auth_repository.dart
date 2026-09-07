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
abstract interface class IAuthRepository {
  Stream<User?> watchUser();

  User? get currentUser;

  Future<Either<UserCredential, Failure>> signInWithGoogle();

  Future<Either<AppleSignInResult, Failure>> signInWithApple();

  Future<void> signOut();
}

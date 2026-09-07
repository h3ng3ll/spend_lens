import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failures/failure.dart';
import '../repositories/i_auth_repository.dart';

/// Google sign-in — one operation (A1 SRP).
class GoogleSignInUseCase {
  final IAuthRepository _authRepository;

  const GoogleSignInUseCase(this._authRepository);

  Future<Either<UserCredential, Failure>> call() =>
      _authRepository.signInWithGoogle();
}

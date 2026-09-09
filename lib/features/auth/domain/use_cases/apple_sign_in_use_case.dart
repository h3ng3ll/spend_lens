import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../models/apple_sign_in_result/apple_sign_in_result.dart';
import '../repositories/i_auth_repository.dart';

/// Apple sign-in — one operation (A1 SRP).
class AppleSignInUseCase {
  final IAuthRepository _authRepository;

  const AppleSignInUseCase(this._authRepository);

  Future<Either<Failure, AppleSignInResult>> call() =>
      _authRepository.signInWithApple();
}

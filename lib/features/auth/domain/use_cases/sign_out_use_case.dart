import '../repositories/i_auth_repository.dart';

/// Sign-out — one operation (A1 SRP).
class SignOutUseCase {
  final IAuthRepository _authRepository;

  const SignOutUseCase(this._authRepository);

  Future<void> call() => _authRepository.signOut();
}

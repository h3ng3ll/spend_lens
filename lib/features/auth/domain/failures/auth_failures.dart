import '../../../../core/failures/failure.dart';

/// Auth failure hierarchy (design_spendlens.md §9 bug 4).
///
/// **Bug 4 fixed here.** The reference template split its errors into TWO
/// unrelated hierarchies — Google's Firebase path returned
/// `Either<UserCredential, Exceptions>` (a project-local `Exceptions`
/// marker interface) while Apple's returned `Either<AppleSignInResult,
/// Failure>` (the project's real `Failure` base) — so a single
/// `AuthRepository.signIn*` caller could not handle both failure paths with
/// one `.fold` branch. Every failure in this app is a [Failure] subtype;
/// there is no second `Exceptions` hierarchy.
class GoogleSignInFailure extends Failure {
  const GoogleSignInFailure() : super('Google sign-in failed.');
}

class GoogleSignInCanceledFailure extends Failure {
  const GoogleSignInCanceledFailure() : super('Google sign-in was canceled.');
}

class GoogleSignInUnconfiguredFailure extends Failure {
  const GoogleSignInUnconfiguredFailure()
    : super('Google sign-in is not configured yet.');
}

class AppleSignInFailure extends Failure {
  const AppleSignInFailure() : super('Apple sign-in failed.');
}

class AppleSignInCanceledFailure extends Failure {
  const AppleSignInCanceledFailure() : super('Apple sign-in was canceled.');
}

class AppleSignInUnsupportedPlatformFailure extends Failure {
  const AppleSignInUnsupportedPlatformFailure()
    : super('Sign in with Apple is not supported on this platform.');
}

class AuthUnavailableFailure extends Failure {
  const AuthUnavailableFailure()
    : super('Sign-in is not available right now.');
}

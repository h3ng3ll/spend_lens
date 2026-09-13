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
///
/// **Diagnosability (silent-sign-in-button fix).** Every failure below now
/// carries a [diagnostic]: the underlying platform code/exception text that
/// caused it. The user-facing [message] stays short and human; [diagnostic]
/// is what goes to the log and to the debug-build toast. Without it, a
/// `providerConfigurationError` (a missing Android OAuth client / unregistered
/// SHA-1 — the actual root cause of "the buttons do nothing") was
/// indistinguishable from an ordinary network hiccup, because a bare
/// `catch (_)` discarded the exception before anyone could read it.
abstract class AuthFailure extends Failure {
  /// The underlying platform cause — an exception code, a plugin message, a
  /// Firebase `auth/...` code. Empty only when there genuinely was none.
  final String diagnostic;

  const AuthFailure(super.message, {this.diagnostic = ''});

  /// `message` for release UI; `message — diagnostic` when a cause is known.
  String get verboseMessage =>
      diagnostic.isEmpty ? message : '$message ($diagnostic)';
}

class GoogleSignInFailure extends AuthFailure {
  const GoogleSignInFailure({super.diagnostic})
    : super('Google sign-in failed.');
}

class GoogleSignInCanceledFailure extends AuthFailure {
  const GoogleSignInCanceledFailure({super.diagnostic})
    : super('Google sign-in was canceled.');
}

class GoogleSignInUnconfiguredFailure extends AuthFailure {
  const GoogleSignInUnconfiguredFailure({super.diagnostic})
    : super('Google sign-in is not configured yet.');
}

class AppleSignInFailure extends AuthFailure {
  const AppleSignInFailure({super.diagnostic}) : super('Apple sign-in failed.');
}

class AppleSignInCanceledFailure extends AuthFailure {
  const AppleSignInCanceledFailure({super.diagnostic})
    : super('Apple sign-in was canceled.');
}

class AppleSignInUnsupportedPlatformFailure extends AuthFailure {
  const AppleSignInUnsupportedPlatformFailure({super.diagnostic})
    : super('Sign in with Apple is not supported on this platform.');
}

class AccountDeletionFailure extends AuthFailure {
  const AccountDeletionFailure({super.diagnostic})
    : super("Couldn't delete your account.");
}

/// The user dismissed the re-authentication sheet that account deletion needs.
///
/// Distinct from [AccountDeletionFailure] so the UI can stay quiet, exactly as
/// a cancelled sign-in does: the user chose to back out, and telling them their
/// deletion "failed" would misrepresent their own decision.
class AccountDeletionCanceledFailure extends AuthFailure {
  const AccountDeletionCanceledFailure({super.diagnostic})
    : super('Account deletion was canceled.');
}

class AuthUnavailableFailure extends AuthFailure {
  const AuthUnavailableFailure({super.diagnostic})
    : super('Sign-in is not available right now.');
}

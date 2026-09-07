part of 'auth_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension AuthStateX on AuthState {
  bool get isSignedOut => status == EAuthStatus.signedOut;

  bool get isSigningIn => status == EAuthStatus.signingIn;

  bool get isSignedIn => status == EAuthStatus.signedIn;

  bool get isFailed => status == EAuthStatus.failed;

  /// Alias for [isSigningIn] — the minimum `isLoading` contract (A3 rule 9).
  bool get isLoading => isSigningIn;

  /// Alias for [isSignedIn] — the minimum `isReady`/`isSuccess` contract
  /// (A3 rule 9).
  bool get isReady => isSignedIn;
}

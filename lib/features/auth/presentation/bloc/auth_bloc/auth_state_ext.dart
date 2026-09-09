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

  /// Every state in which the user has no account attached — signed out, an
  /// attempt in flight, and a FAILED attempt.
  ///
  /// The sign-in offer must be gated on this, never on [isSignedOut] alone:
  /// a failed authorization leaves the bloc in [EAuthStatus.failed], which is
  /// neither `signedOut` nor `signedIn`, so an `isSignedOut`/`isSignedIn` pair
  /// of branches renders NOTHING and the Google/Apple buttons disappear with
  /// no way to retry.
  bool get isNotSignedIn => !isSignedIn;

  /// `true` when signed in through Apple rather than Google.
  ///
  /// Read this instead of negating [isGoogleAccount] directly: that flag is
  /// only meaningful while signed in, so a bare `!isGoogleAccount` reports
  /// "Apple" for a signed-OUT user too.
  bool get isAppleAccount => isSignedIn && !isGoogleAccount;
}

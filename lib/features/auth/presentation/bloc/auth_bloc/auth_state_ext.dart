part of 'auth_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension AuthStateX on AuthState {
  bool get isSignedOut => status == EAuthStatus.signedOut;

  bool get isSignedIn => status == EAuthStatus.signedIn;

  bool get isFailed => status == EAuthStatus.failed;
}

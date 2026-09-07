part of 'auth_bloc.dart';

enum EAuthStatus { signedOut, signingIn, signedIn, failed }

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(EAuthStatus.signedOut) EAuthStatus status,
    @Default('') String errorMessage,

    /// `true` when signed in via Google, `false` for Apple/anonymous. Only
    /// meaningful when `status == EAuthStatus.signedIn`.
    @Default(false) bool isGoogleAccount,

    /// The signed-in user's email, for the Profile artboard's `account`
    /// row. Empty when signed out.
    @Default('') String email,
  }) = _AuthState;
}

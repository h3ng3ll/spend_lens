part of 'auth_bloc.dart';

enum EAuthStatus { signedOut, signedIn, failed }

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(EAuthStatus.signedOut) EAuthStatus status,
    @Default('') String errorMessage,
  }) = _AuthState;
}

part of 'auth_bloc.dart';

/// Intent events (BLoC rule A3.7) — the UI dispatches these and never
/// branches on state to choose between them.
@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Dispatched once from `main()` (BLoC rule A3.8) to subscribe to
  /// Firebase's own auth-state stream — never re-dispatched from a screen.
  const factory AuthEvent.watch() = _Watch;

  const factory AuthEvent.signInGoogle() = _SignInGoogle;

  const factory AuthEvent.signInApple() = _SignInApple;

  const factory AuthEvent.signOut() = _SignOut;
}

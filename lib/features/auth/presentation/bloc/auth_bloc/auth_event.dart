part of 'auth_bloc.dart';

/// Intent events (BLoC rule A3.7) — the UI dispatches these and never
/// branches on state to choose between them.
@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Dispatched once from `main()` (BLoC rule A3.8) to subscribe to
  /// Firebase's own auth-state stream — never re-dispatched from a screen.
  const factory AuthEvent.watch() = _Watch;

  /// Subscribes to the stored profile (name) and the cached avatar bytes.
  /// Dispatched once from `main()` alongside [AuthEvent.watch], for the same
  /// reason and under the same rule.
  const factory AuthEvent.watchProfile() = _WatchProfile;

  const factory AuthEvent.watchAvatar() = _WatchAvatar;

  /// Fills the stored profile from the CURRENT signed-in Firebase user.
  ///
  /// Dispatched internally by the bloc when `watchUser()` reports a session —
  /// including one RESTORED at launch, which never passes through a sign-in
  /// handler. Not dispatched by the UI.
  ///
  /// Carries NO payload, deliberately. `AppObserver.onEvent` interpolates every
  /// event into the log (`'[Event] in $bloc: $event'`), and a `User` on this
  /// event would print its email there — the exact leak
  /// `no_pii_in_logging_test.dart` guards against. The handler re-reads the
  /// user from the repository instead, where it is already available.
  const factory AuthEvent.seedProfile() = _SeedProfile;

  const factory AuthEvent.signInGoogle() = _SignInGoogle;

  const factory AuthEvent.signInApple() = _SignInApple;

  const factory AuthEvent.signOut() = _SignOut;

  /// Permanently deletes the account and its data (Apple Guideline 5.1.1(v)).
  /// The scope is the user's explicit choice — see [EAccountDeletionScope].
  const factory AuthEvent.deleteAccount(EAccountDeletionScope scope) =
      _DeleteAccount;
}

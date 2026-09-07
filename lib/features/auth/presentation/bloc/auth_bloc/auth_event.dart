part of 'auth_bloc.dart';

/// M9 adds `signInGoogle` / `signInApple` / `signOut` events here, wired to
/// `firebase_auth` per design_spendlens.md §9. M4 has no events yet — the
/// bloc's only job right now is to exist and be resolvable as the
/// app-lifetime `registerLazySingleton` the spec names.
@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.placeholder() = _Placeholder;
}

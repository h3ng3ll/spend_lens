part of 'settings_bloc.dart';

@freezed
sealed class SettingsEvent with _$SettingsEvent {
  /// Reconciles the bloc's state with whatever is on disk. Idempotent — safe
  /// to dispatch even though the bloc's initial state was already seeded
  /// synchronously before `runApp` (see `settings_bloc.dart`).
  const factory SettingsEvent.watch() = _Watch;

  /// Sets the interface language. `code == null` means "follow the device
  /// locale". UI dispatches the user's pick directly — this is a selection,
  /// not a toggle, so it legitimately carries a payload.
  const factory SettingsEvent.setLocale({required String? code}) = _SetLocale;

  /// Sets the display currency code (e.g. `'MDL'`, `'EUR'`).
  const factory SettingsEvent.setCurrency({required String code}) =
      _SetCurrency;

  /// Toggle intent — NO payload. The handler reads `state.settings.themeMode`
  /// and flips it internally (BLoC rule A3.11): light ↔ dark. `system` is
  /// reachable only as the pre-first-choice default, never re-selected by
  /// this toggle.
  const factory SettingsEvent.toggleTheme() = _ToggleTheme;

  /// Persists that onboarding finished. Dispatched by the Onboarding Get
  /// Started action (M4 router plumbing only — the real multi-step
  /// onboarding UI is M10); `redirect` in `init_router.dart` reads
  /// `settings.onboardingCompleted` to decide Splash → Onboarding vs. Home.
  const factory SettingsEvent.completeOnboarding() = _CompleteOnboarding;

  /// Toggle intent — NO payload (BLoC rule A3.11). The handler reads
  /// `state.settings.flashMode` and cycles it internally:
  /// auto → on → off → auto. Dispatched by the Scanner screen's flash
  /// control (design_spendlens.md §6/§10 — the flash preference is a
  /// device-level setting persisted on [AppSettings], not scanner-screen
  /// state, so it belongs on this app-lifetime bloc rather than the
  /// screen-scoped `ScannerBloc`).
  const factory SettingsEvent.toggleFlashMode() = _ToggleFlashMode;
}

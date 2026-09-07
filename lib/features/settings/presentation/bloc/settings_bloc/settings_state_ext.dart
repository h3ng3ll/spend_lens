part of 'settings_bloc.dart';

extension SettingsStateX on SettingsState {
  bool get isInitial => status == ESettingsStatus.initial;

  bool get isLoading => status == ESettingsStatus.loading;

  bool get isReady => status == ESettingsStatus.ready;

  bool get isFailed => status == ESettingsStatus.failed;

  /// The effective [Locale] to pass to `MaterialApp.locale`. `null` when the
  /// user has not chosen one — `MaterialApp` then resolves from the device,
  /// which is the desired "follow device" behavior (never defaulted to a
  /// concrete language, per the language-picker chronic bug's trap A).
  Locale? get resolvedLocale =>
      settings.localeCode == null ? null : Locale(settings.localeCode!);

  /// The effective [ThemeMode] to pass to `MaterialApp.themeMode`.
  ThemeMode get resolvedThemeMode => switch (settings.themeMode) {
        EAppThemeMode.system => ThemeMode.system,
        EAppThemeMode.light => ThemeMode.light,
        EAppThemeMode.dark => ThemeMode.dark,
      };
}

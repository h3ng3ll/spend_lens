import 'package:freezed_annotation/freezed_annotation.dart';

import 'e_app_theme_mode.dart';
import 'e_flash_mode.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// The single persisted app-settings record (design_spendlens.md §3).
///
/// M2 seeded the first three fields (`localeCode`, `currencyCode`,
/// `themeMode` — field indices 0–2, LOCKED, never reordered: stored data
/// depends on them). M3 APPENDS `onboardingCompleted`, `flashMode`,
/// `dataCleared` as field indices 3–5 — this file only ever grows new
/// trailing fields; it never re-shapes the box (`settings`, singular key
/// `'app_settings'`).
///
/// `localeCode` is deliberately NULLABLE:
/// `null` means "follow the device locale" (recorded global bug
/// `language-picker-writes-domain-field-materialapp-locale-never-bound`,
/// trap A — a non-nullable default forces one language onto every user
/// regardless of device locale, which is a regression).
@freezed
sealed class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// `null` = follow the device locale. Never defaulted to a concrete
    /// language code.
    String? localeCode,

    /// ISO 4217 currency code used for totals/analytics display. Receipts
    /// keep their own printed currency regardless of this setting
    /// (design_spendlens.md §4 "no conversion" resolution) — this is
    /// display-only.
    @Default('MDL') String currencyCode,
    @Default(EAppThemeMode.system) EAppThemeMode themeMode,

    /// Whether the user has completed onboarding (M10). Read by the
    /// splash → onboarding/home redirect once the router lands (M5).
    @Default(false) bool onboardingCompleted,

    /// The scanner's persisted camera-flash preference (M7).
    @Default(EFlashMode.auto) EFlashMode flashMode,

    /// design_spendlens.md §7 — set `true` by "Delete all records"; the
    /// seed guard checks `isEmpty && !dataCleared` so a deliberately
    /// emptied app never silently repopulates. Any restore path sets this
    /// back to `false`.
    @Default(false) bool dataCleared,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

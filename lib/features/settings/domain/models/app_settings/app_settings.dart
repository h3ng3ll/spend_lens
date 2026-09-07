import 'package:freezed_annotation/freezed_annotation.dart';

import 'e_app_theme_mode.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// The single persisted app-settings record (design_spendlens.md §3).
///
/// M2 seeds the three fields this milestone needs (`localeCode`,
/// `currencyCode`, `themeMode` — the Currency sheet also switches and
/// persists per the M2 acceptance bar); M3 extends this with
/// `onboardingCompleted`, `flashMode`, `dataCleared` when the full 8-entity
/// Hive layer lands. Kept as ONE freezed model + ONE box (`settings`,
/// singular key `'app_settings'`) so M3 only ADDS fields — it never
/// re-shapes this box.
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
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

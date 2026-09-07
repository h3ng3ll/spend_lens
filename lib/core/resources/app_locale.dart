import 'package:flutter/material.dart';

/// Locale configuration (design_spendlens.md binding decision 4 / §4.4: all
/// 7 languages — en, ro, ru, uk, es, de, fr — ported from `i18n.js`).
///
/// The actual "which locale is active right now" resolution lives in
/// `SettingsBloc` / `SettingsStateX.resolvedLocale` (M2) — that is what
/// `MaterialApp.locale` binds to in `main.dart`. This class only declares the
/// static list of locales the app SUPPORTS and the language-picker UI reads.
class AppLocale {
  const AppLocale._();

  /// Locale used when the device locale is not in [supportedLocales].
  static const Locale fallbackLocale = Locale('en');

  /// All 7 languages the design + i18n.js support, in the picker's display
  /// order (matches the design's Language sheet).
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ro'),
    Locale('ru'),
    Locale('uk'),
    Locale('es'),
    Locale('de'),
    Locale('fr'),
  ];
}

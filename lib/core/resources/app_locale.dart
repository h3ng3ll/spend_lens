import 'package:flutter/material.dart';

/// Locale configuration.
///
/// design_spendlens.md binding decision 4: all 7 languages (en, ro, ru, uk,
/// es, de, fr), ported from `i18n.js`. M1 seeds the supported-locales list so
/// `MaterialApp.supportedLocales` is correct from day one; the ARB files
/// themselves and reading `startLocale` from persisted Settings land in M2.
class AppLocale {
  const AppLocale._();

  /// Locale used when the device locale is not in [supportedLocales].
  static const Locale fallbackLocale = Locale('en');

  /// Overrides the device locale until persisted Settings are wired (M2).
  static const Locale startLocale = Locale('en');

  /// All 7 languages the design + i18n.js support.
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

import 'package:flutter/material.dart';

import 'colors/app_color_scheme.dart';
import 'text/app_text_theme.dart';

/// App theme data — both light and dark (design_spendlens.md binding
/// decision 2: this app is NOT dark-only; both themes are required, with a
/// persisted Settings Appearance toggle wired via `SettingsBloc` +
/// `MaterialApp.themeMode`).
///
/// `useMaterial3: true` on BOTH themes (template bug §9 bug 7 fixed: the
/// template had `false` on dark only).
///
/// Material's own [ColorScheme] is populated from [AppColorScheme] only for
/// the handful of stock widgets that read `Theme.of(context).colorScheme`
/// directly (e.g. text-selection handles, default `Material` ripple).
/// Screens themselves must never read `Theme.of(context).colorScheme.*` —
/// always `AppColorScheme.of(context)`.
abstract class AppThemeData {
  static final _lightColorScheme = AppColorScheme.light();
  static final _darkColorScheme = AppColorScheme.dark();
  static final _textTheme = AppTextTheme.base();

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightColorScheme.bg,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.bg,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightColorScheme.ink),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: _lightColorScheme.accent,
      onPrimary: _lightColorScheme.onAccent,
      secondary: _lightColorScheme.accent2,
      onSecondary: _lightColorScheme.onAccent,
      error: _lightColorScheme.error,
      onError: _lightColorScheme.onError,
      surface: _lightColorScheme.cardSolid,
      onSurface: _lightColorScheme.ink,
      onSurfaceVariant: _lightColorScheme.sec,
    ),
    primaryColor: _lightColorScheme.accent,
    extensions: [_textTheme, _lightColorScheme],
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkColorScheme.bg,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.bg,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkColorScheme.ink),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _darkColorScheme.accent,
      onPrimary: _darkColorScheme.onAccent,
      secondary: _darkColorScheme.accent2,
      onSecondary: _darkColorScheme.onAccent,
      error: _darkColorScheme.error,
      onError: _darkColorScheme.onError,
      surface: _darkColorScheme.cardSolid,
      onSurface: _darkColorScheme.ink,
      onSurfaceVariant: _darkColorScheme.sec,
    ),
    primaryColor: _darkColorScheme.accent,
    extensions: [_textTheme, _darkColorScheme],
  );
}

import 'package:flutter/material.dart';

import 'colors/app_color_scheme.dart';
import 'text/app_text_theme.dart';

/// App theme data — both light and dark (design_spendlens.md binding decision
/// 2: this app is NOT dark-only; both themes are required with a persisted
/// Settings Appearance toggle, wired in M2).
///
/// Template bug fixed here (§9 bug 7 / spec §1 Step 2): `useMaterial3: true`
/// on BOTH themes — the template had `false` on dark only.
abstract class AppThemeData {
  static final _lightColorScheme = AppColorScheme.light();
  static final _darkColorScheme = AppColorScheme.dark();
  static final _textTheme = AppTextTheme.base();

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.background,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightColorScheme.onBackground),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: _lightColorScheme.primary,
      onPrimary: _lightColorScheme.onPrimary,
      secondary: _lightColorScheme.secondary,
      onSecondary: _lightColorScheme.onSecondary,
      error: _lightColorScheme.error,
      onError: _lightColorScheme.onError,
      surface: _lightColorScheme.surface,
      onSurface: _lightColorScheme.onSurface,
      onSurfaceVariant: _lightColorScheme.onSurfaceVariant,
    ),
    primaryColor: _lightColorScheme.primary,
    extensions: [_textTheme, _lightColorScheme],
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.background,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkColorScheme.onBackground),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _darkColorScheme.primary,
      onPrimary: _darkColorScheme.onPrimary,
      secondary: _darkColorScheme.secondary,
      onSecondary: _darkColorScheme.onSecondary,
      error: _darkColorScheme.error,
      onError: _darkColorScheme.onError,
      surface: _darkColorScheme.surface,
      onSurface: _darkColorScheme.onSurface,
      onSurfaceVariant: _darkColorScheme.onSurfaceVariant,
    ),
    primaryColor: _darkColorScheme.primary,
    extensions: [_textTheme, _darkColorScheme],
  );
}

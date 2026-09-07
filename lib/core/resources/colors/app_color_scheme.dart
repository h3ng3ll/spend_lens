import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App color scheme.
///
/// M1 ships a correct minimal skeleton so both themes render distinctly and
/// `AppColorScheme.of` never throws. Template bugs fixed here (per
/// design_spendlens.md §9): the dark factory is a real dark palette, not an
/// all-white stub; `of()` throws a plain English message, not Russian.
/// M2 extends this to the full ~26-field set from design_spendlens.md §4.2.
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  /// The base color for app.
  final Color primary;

  /// The color of the elements that appears on top of a [primary].
  final Color onPrimary;

  /// A secondary color for the app.
  final Color secondary;

  /// The color of the elements that appears on top of a [secondary].
  final Color onSecondary;

  /// The color of inactive icon (in buttons/switchers... etc)
  final Color inactiveSecondary;

  /// Surface colors affect surfaces of components, such as cards, sheets, and menus.
  final Color surface;

  /// The color of the elements that appears on top of a [surface].
  final Color onSurface;

  /// The background color appears behind scrollable content.
  final Color background;

  /// The color of the elements that appears on top of a [background].
  final Color onBackground;

  /// Color for showing errors.
  final Color error;

  /// The color of the elements that appears on top of a [error].
  final Color onError;

  /// Color for showing selected items.
  final Color selectedItem;

  /// Color for showing unselected items.
  final Color unselectedItem;

  final Color onSurfaceVariant;

  const AppColorScheme._({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.inactiveSecondary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.error,
    required this.onError,
    required this.selectedItem,
    required this.unselectedItem,
    required this.onSurfaceVariant,
  });

  /// Light theme of the app.
  factory AppColorScheme.light() => AppColorScheme._(
        primary: AppColors.accentDark.value,
        onPrimary: AppColors.white.value,
        secondary: AppColors.neutral900.value,
        onSecondary: AppColors.white.value,
        inactiveSecondary: AppColors.neutral100.value,
        surface: AppColors.white.value,
        onSurface: AppColors.neutral900.value,
        background: AppColors.neutralWhite.value,
        onBackground: AppColors.neutral900.value,
        error: AppColors.warn.value,
        onError: AppColors.white.value,
        selectedItem: AppColors.accentDark.value,
        unselectedItem: AppColors.neutral100.value,
        onSurfaceVariant: AppColors.neutral900.value.withValues(alpha: 0.6),
      );

  /// Dark theme of the app.
  factory AppColorScheme.dark() => AppColorScheme._(
        primary: AppColors.accent.value,
        onPrimary: AppColors.neutral900.value,
        secondary: AppColors.white.value,
        onSecondary: AppColors.neutral900.value,
        inactiveSecondary: AppColors.neutral800.value,
        surface: AppColors.neutral800.value,
        onSurface: AppColors.white.value,
        background: AppColors.neutral900.value,
        onBackground: AppColors.white.value,
        error: AppColors.warn.value,
        onError: AppColors.white.value,
        selectedItem: AppColors.accent.value,
        unselectedItem: AppColors.neutral800.value,
        onSurfaceVariant: AppColors.white.value.withValues(alpha: 0.6),
      );

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? inactiveSecondary,
    Color? surface,
    Color? onSurface,
    Color? background,
    Color? onBackground,
    Color? error,
    Color? onError,
    Color? selectedItem,
    Color? unselectedItem,
    Color? onSurfaceVariant,
  }) {
    return AppColorScheme._(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      inactiveSecondary: inactiveSecondary ?? this.inactiveSecondary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      selectedItem: selectedItem ?? this.selectedItem,
      unselectedItem: unselectedItem ?? this.unselectedItem,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
    );
  }

  @override
  AppColorScheme lerp(
    ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) return this;

    return copyWith(
      primary: Color.lerp(primary, other.primary, t),
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t),
      inactiveSecondary: Color.lerp(
        inactiveSecondary,
        other.inactiveSecondary,
        t,
      ),
      surface: Color.lerp(surface, other.surface, t),
      onSurface: Color.lerp(onSurface, other.onSurface, t),
      background: Color.lerp(background, other.background, t),
      onBackground: Color.lerp(onBackground, other.onBackground, t),
      error: Color.lerp(error, other.error, t),
      onError: Color.lerp(onError, other.onError, t),
      selectedItem: Color.lerp(selectedItem, other.selectedItem, t),
      unselectedItem: Color.lerp(unselectedItem, other.unselectedItem, t),
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t),
    );
  }

  /// Returns the color scheme for the app from [context].
  static AppColorScheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorScheme>() ??
      (throw Exception('AppColorScheme not found in the current theme'));
}

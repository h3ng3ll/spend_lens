import 'package:flutter/material.dart';

import 'app_text_style.dart';

/// M1 minimal text theme covering only the styles the copied `core/` widgets
/// reference. M2 replaces this with the full design-role-named scale from
/// design_spendlens.md §4.3.
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  final TextStyle regular12;
  final TextStyle regular14;
  final TextStyle medium12;
  final TextStyle medium14;
  final TextStyle bold20;

  const AppTextTheme._({
    required this.regular12,
    required this.regular14,
    required this.medium12,
    required this.medium14,
    required this.bold20,
  });

  /// Base app text theme.
  factory AppTextTheme.base() => AppTextTheme._(
        regular12: AppTextStyle.regular12.value,
        regular14: AppTextStyle.regular14.value,
        medium12: AppTextStyle.medium12.value,
        medium14: AppTextStyle.medium14.value,
        bold20: AppTextStyle.bold20.value,
      );

  @override
  AppTextTheme copyWith({
    TextStyle? regular12,
    TextStyle? regular14,
    TextStyle? medium12,
    TextStyle? medium14,
    TextStyle? bold20,
  }) {
    return AppTextTheme._(
      regular12: regular12 ?? this.regular12,
      regular14: regular14 ?? this.regular14,
      medium12: medium12 ?? this.medium12,
      medium14: medium14 ?? this.medium14,
      bold20: bold20 ?? this.bold20,
    );
  }

  @override
  AppTextTheme lerp(
    ThemeExtension<AppTextTheme>? other,
    double t,
  ) {
    if (other is! AppTextTheme) {
      return this;
    }

    return copyWith(
      regular12: TextStyle.lerp(regular12, other.regular12, t),
      regular14: TextStyle.lerp(regular14, other.regular14, t),
      medium12: TextStyle.lerp(medium12, other.medium12, t),
      medium14: TextStyle.lerp(medium14, other.medium14, t),
      bold20: TextStyle.lerp(bold20, other.bold20, t),
    );
  }

  /// Returns the text theme for the app from [context].
  static AppTextTheme of(BuildContext context) {
    return Theme.of(context).extension<AppTextTheme>() ??
        (throw Exception('AppTextTheme not found in the current theme'));
  }
}

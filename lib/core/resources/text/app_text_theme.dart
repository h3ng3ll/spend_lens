import 'package:flutter/material.dart';

import 'app_text_style.dart';

/// The full design-role-named type scale (design_spendlens.md §4.3), exposed
/// as a [ThemeExtension] so widgets read it via `AppTextTheme.of(context)`
/// rather than a raw enum lookup.
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  final TextStyle hero44;
  final TextStyle heroCurrency22;
  final TextStyle screenTitle28;
  final TextStyle detailAmount40;
  final TextStyle statValue20;
  final TextStyle headline17;
  final TextStyle headline17Semi;
  final TextStyle body17;
  final TextStyle subhead15;
  final TextStyle footnote13;
  final TextStyle sectionLabel12;
  final TextStyle tabLabel10;
  final TextStyle amountInput32;

  const AppTextTheme._({
    required this.hero44,
    required this.heroCurrency22,
    required this.screenTitle28,
    required this.detailAmount40,
    required this.statValue20,
    required this.headline17,
    required this.headline17Semi,
    required this.body17,
    required this.subhead15,
    required this.footnote13,
    required this.sectionLabel12,
    required this.tabLabel10,
    required this.amountInput32,
  });

  /// Base app text theme.
  factory AppTextTheme.base() => AppTextTheme._(
        hero44: AppTextStyle.hero44.value,
        heroCurrency22: AppTextStyle.heroCurrency22.value,
        screenTitle28: AppTextStyle.screenTitle28.value,
        detailAmount40: AppTextStyle.detailAmount40.value,
        statValue20: AppTextStyle.statValue20.value,
        headline17: AppTextStyle.headline17.value,
        headline17Semi: AppTextStyle.headline17Semi.value,
        body17: AppTextStyle.body17.value,
        subhead15: AppTextStyle.subhead15.value,
        footnote13: AppTextStyle.footnote13.value,
        sectionLabel12: AppTextStyle.sectionLabel12.value,
        tabLabel10: AppTextStyle.tabLabel10.value,
        amountInput32: AppTextStyle.amountInput32.value,
      );

  @override
  AppTextTheme copyWith({
    TextStyle? hero44,
    TextStyle? heroCurrency22,
    TextStyle? screenTitle28,
    TextStyle? detailAmount40,
    TextStyle? statValue20,
    TextStyle? headline17,
    TextStyle? headline17Semi,
    TextStyle? body17,
    TextStyle? subhead15,
    TextStyle? footnote13,
    TextStyle? sectionLabel12,
    TextStyle? tabLabel10,
    TextStyle? amountInput32,
  }) {
    return AppTextTheme._(
      hero44: hero44 ?? this.hero44,
      heroCurrency22: heroCurrency22 ?? this.heroCurrency22,
      screenTitle28: screenTitle28 ?? this.screenTitle28,
      detailAmount40: detailAmount40 ?? this.detailAmount40,
      statValue20: statValue20 ?? this.statValue20,
      headline17: headline17 ?? this.headline17,
      headline17Semi: headline17Semi ?? this.headline17Semi,
      body17: body17 ?? this.body17,
      subhead15: subhead15 ?? this.subhead15,
      footnote13: footnote13 ?? this.footnote13,
      sectionLabel12: sectionLabel12 ?? this.sectionLabel12,
      tabLabel10: tabLabel10 ?? this.tabLabel10,
      amountInput32: amountInput32 ?? this.amountInput32,
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
      hero44: TextStyle.lerp(hero44, other.hero44, t),
      heroCurrency22: TextStyle.lerp(heroCurrency22, other.heroCurrency22, t),
      screenTitle28: TextStyle.lerp(screenTitle28, other.screenTitle28, t),
      detailAmount40: TextStyle.lerp(detailAmount40, other.detailAmount40, t),
      statValue20: TextStyle.lerp(statValue20, other.statValue20, t),
      headline17: TextStyle.lerp(headline17, other.headline17, t),
      headline17Semi: TextStyle.lerp(headline17Semi, other.headline17Semi, t),
      body17: TextStyle.lerp(body17, other.body17, t),
      subhead15: TextStyle.lerp(subhead15, other.subhead15, t),
      footnote13: TextStyle.lerp(footnote13, other.footnote13, t),
      sectionLabel12: TextStyle.lerp(sectionLabel12, other.sectionLabel12, t),
      tabLabel10: TextStyle.lerp(tabLabel10, other.tabLabel10, t),
      amountInput32: TextStyle.lerp(amountInput32, other.amountInput32, t),
    );
  }

  /// Returns the text theme for the app from [context].
  static AppTextTheme of(BuildContext context) {
    return Theme.of(context).extension<AppTextTheme>() ??
        (throw Exception('AppTextTheme not found in the current theme'));
  }
}

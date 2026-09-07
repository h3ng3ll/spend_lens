import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';

/// Home's hero block: the big monthly total, the "spent this month"
/// subtitle, and the trend line vs the previous month
/// (design_spendlens.md — Home artboard's `totalText`/`cur` +
/// `spentThisMonth` + `deltaText`/`vsAugust` block).
///
/// Trend color is NEVER `scheme.error` — amber (`scheme.trendUp`) when
/// spending rose, green (`scheme.trendDown`) when it fell
/// (design_spendlens.md §4.2: `trendUp`/`trendDown` are their own semantic
/// pair).
class HomeHeroSection extends StatelessWidget {
  final String totalText;
  final String currencyCode;
  final String deltaText;
  final bool spendingRose;
  final String previousMonthLabel;
  final String previousMonthTotalText;

  const HomeHeroSection({
    super.key,
    required this.totalText,
    required this.currencyCode,
    required this.deltaText,
    required this.spendingRose,
    required this.previousMonthLabel,
    required this.previousMonthTotalText,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final trendColor = spendingRose ? scheme.trendUp : scheme.trendDown;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: totalText,
                style: textTheme.hero44.copyWith(
                  color: scheme.ink,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: currencyCode,
                style: textTheme.heroCurrency22.copyWith(color: scheme.sec),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            lo.spentThisMonth,
            style: textTheme.subhead15.copyWith(color: scheme.sec),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: deltaText,
                  style: textTheme.subhead15.copyWith(
                    color: trendColor,
                    fontWeight: FontWeight.w600,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                TextSpan(
                  text: ' ${lo.vs(previousMonthLabel)} · $previousMonthTotalText'
                      ' $currencyCode',
                  style: textTheme.subhead15.copyWith(
                    color: scheme.sec,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';

/// The month-over-month delta line beneath the total-spent hero
/// (`SpendLens Prototype.dc.html`'s `mDelta`/`mDeltaColor` row) — now real,
/// computed by the M6 calculator's `percentChangeVsPreviousMonth`
/// (design_spendlens.md §10).
///
/// Trend coloring is amber when spending ROSE, green when it FELL — NEVER
/// red (design_spendlens.md §4.2). Uses `scheme.trendUp`/`trendDown` only.
class AnalyticsTotalDelta extends StatelessWidget {
  final double percentChange;
  final String previousMonthLabel;

  const AnalyticsTotalDelta({
    super.key,
    required this.percentChange,
    required this.previousMonthLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final rose = percentChange > 0;
    final color = rose ? scheme.trendUp : scheme.trendDown;
    final sign = rose ? '+' : '−';

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$sign${percentChange.abs().round()}% ',
            style: textTheme.subhead15.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          TextSpan(
            text: lo.vs(previousMonthLabel),
            style: textTheme.subhead15.copyWith(color: scheme.sec),
          ),
        ],
      ),
    );
  }
}

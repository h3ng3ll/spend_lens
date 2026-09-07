import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';

/// The overall first-to-last price change line (design_spendlens.md §11 —
/// reproduces the design's worked example, `18.50 → 22.90 = +23.8%`).
///
/// Trend coloring is amber when the price ROSE, green when it FELL — NEVER
/// red (design_spendlens.md §4.2). Uses `scheme.trendUp`/`trendDown`,
/// never `scheme.error`.
class PriceHistoryChangeLabel extends StatelessWidget {
  final double percentChange;

  const PriceHistoryChangeLabel({super.key, required this.percentChange});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final rose = percentChange > 0;
    final color = rose ? scheme.trendUp : scheme.trendDown;
    final directionWord = rose ? lo.trendIncreased : lo.trendDecreased;

    return Text(
      lo.priceHistoryChangeLabel(
        directionWord,
        percentChange.abs().toStringAsFixed(1),
      ),
      style: textTheme.subhead15.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';

/// The big total-spent figure (`SpendLens Prototype.dc.html`'s `mTotal`
/// row) — currency suffix in a smaller secondary style beside it, per the
/// design.
///
/// M5 renders only the total (a real, honestly-computed sum). The
/// month-over-month delta line (`mDelta`/`mDeltaColor`) needs a previous-
/// period comparison, which is the M6 calculator's job
/// (design_spendlens.md §10) — it is not rendered here rather than faked.
class AnalyticsTotalHero extends StatelessWidget {
  final String totalText;
  final String currencyCode;

  const AnalyticsTotalHero({
    super.key,
    required this.totalText,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: totalText,
            style: textTheme.hero44.copyWith(
              color: scheme.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          TextSpan(
            text: ' $currencyCode',
            style: textTheme.heroCurrency22.copyWith(color: scheme.sec),
          ),
        ],
      ),
    );
  }
}

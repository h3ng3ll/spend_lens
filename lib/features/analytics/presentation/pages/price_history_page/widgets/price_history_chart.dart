import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../domain/models/price_history/price_history_point.dart';
import '../painters/price_history_bar_painter.dart';

/// The v1 price-history bar chart (design_spendlens.md §11, spec §54–57;
/// `SpendLens.dc.html`'s bar-chart component).
///
/// One bar per calendar month; a month with no observation renders as a
/// muted, border-only stub — never the same solid fill as a real
/// measurement (`chart-zero-value-bar-paints-the-data-fill-so-empty-reads-
/// as-measured`). Month labels are placed with `LayoutBuilder` +
/// `Positioned`, never a bare `Align` inside the `Stack` — a non-positioned
/// `Align` shrink-wraps to its own child and collapses every computed
/// per-bar offset to one point
/// (`non-positioned-align-in-stack-shrinkwraps-so-every-computed-offset-
/// collapses-to-one-point`).
class PriceHistoryChart extends StatelessWidget {
  static const double _chartHeight = 160.0;

  /// Base label-row height at the platform's default text scale. Scaled by
  /// the active `TextScaler` at build time (below) — the row height itself
  /// must track `textScaleFactor` or an enlarged month label clips against
  /// a literal dp box (recorded chronic:
  /// `sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`).
  /// Terminal state for THIS site: the row is `TextScaler`-scaled and the
  /// `Text` is centered with no `maxLines`/`overflow` clamp, so it grows
  /// with the label instead of clipping it.
  static const double _baseLabelRowHeight = 20.0;

  final List<PriceHistoryPoint> points;

  /// One short month label per [points] entry, already resolved through
  /// `AppLocalizations` (`monthsShort0`..`monthsShort11`) by the caller —
  /// this widget stays localization-agnostic, matching every other shared
  /// presentational widget in the app.
  final List<String> monthLabels;

  const PriceHistoryChart({
    super.key,
    required this.points,
    required this.monthLabels,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    final maxUnitPrice = points.fold<double>(
      0.0,
      (max, point) => point.hasData && point.unitPrice > max
          ? point.unitPrice
          : max,
    );

    final labelRowHeight = MediaQuery.textScalerOf(context).scale(
      _baseLabelRowHeight,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6.0,
      children: [
        SizedBox(
          height: _chartHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;
              return CustomPaint(
                size: size,
                painter: PriceHistoryBarPainter(
                  points: points,
                  maxUnitPrice: maxUnitPrice,
                  barColor: scheme.accent2,
                  emptyBarBorderColor: scheme.line2,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: labelRowHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final slotWidth = constraints.maxWidth / points.length;
              return Stack(
                children: [
                  for (var i = 0; i < points.length; i++)
                    Positioned(
                      left: slotWidth * i,
                      width: slotWidth,
                      top: 0.0,
                      bottom: 0.0,
                      child: Center(
                        child: Text(
                          monthLabels[i],
                          style: textTheme.footnote13.copyWith(
                            color: scheme.ter,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

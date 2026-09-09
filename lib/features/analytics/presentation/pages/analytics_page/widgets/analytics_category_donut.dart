import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../painters/analytics_category_donut_painter.dart';

/// The 112dp category donut plus its centre readout
/// (`SpendLens Prototype.dc.html`: a 112px ring with a 78px hole, the
/// selected slice's percentage over its category name).
///
/// Sizes are the design's own (112 / 78 → a 17dp ring). They are UI layout
/// literals, so they stay inline per project style; only the painter's
/// opacity is named, being a LOGIC value the painter branches on.
class AnalyticsCategoryDonut extends StatelessWidget {
  /// Share of the total per slice, each 0.0–1.0, in legend order.
  final List<double> shares;

  /// One color per slice, parallel to [shares].
  final List<Color> colors;

  final int selectedIndex;

  /// Centre readout: the selected slice's percentage, already rounded.
  final int selectedPercent;

  /// Centre readout: the selected slice's category name.
  final String selectedName;

  const AnalyticsCategoryDonut({
    super.key,
    required this.shares,
    required this.colors,
    required this.selectedIndex,
    required this.selectedPercent,
    required this.selectedName,
  });

  /// The prototype's `hexA(col, '66')` — 0x66/0xFF.
  static const double _unselectedSliceOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return SizedBox(
      width: 112.0,
      height: 112.0,
      child: CustomPaint(
        painter: AnalyticsCategoryDonutPainter(
          shares: shares,
          colors: colors,
          selectedIndex: selectedIndex,
          ringThickness: 17.0,
          unselectedOpacity: _unselectedSliceOpacity,
        ),
        child: Center(
          child: SizedBox(
            width: 78.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$selectedPercent%',
                  maxLines: 1,
                  style: textTheme.statValue20.copyWith(
                    color: scheme.ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  selectedName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.footnote13.copyWith(color: scheme.ter),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

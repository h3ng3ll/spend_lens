import 'package:flutter/material.dart';

import '../../../../domain/models/price_history/price_history_point.dart';

/// Paints the v1 price-history bar chart (`SpendLens.dc.html`'s bar-chart
/// component, the one artifact that HTML file contributes over the newer
/// prototype — design_spendlens.md's Conflicts table).
///
/// One bar per [PriceHistoryPoint]. A minimum height floor keeps every
/// column (including empty ones) visible and the axis readable, but the
/// FILL COLOR is gated on [PriceHistoryPoint.hasData] — this is the fix for
/// the recorded chronic bug
/// `chart-zero-value-bar-paints-the-data-fill-so-empty-reads-as-measured`:
/// the floor answers "should this column be visible?" (yes, always) and is
/// correct; the defect was giving a zero/absent period the SAME saturated
/// fill as a real measurement. Here an empty period paints a muted,
/// BORDER-ONLY stub (`emptyBarColor`, no fill) that is visually
/// unmistakable from a real bar (`barColor`, solid fill) in both themes.
class PriceHistoryBarPainter extends CustomPainter {
  static const double _minBarHeightFraction = 0.06;
  static const double _barBorderWidth = 1.5;
  static const double _barCornerRadius = 4.0;

  final List<PriceHistoryPoint> points;
  final double maxUnitPrice;
  final Color barColor;
  final Color emptyBarBorderColor;

  const PriceHistoryBarPainter({
    required this.points,
    required this.maxUnitPrice,
    required this.barColor,
    required this.emptyBarBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final barSlotWidth = size.width / points.length;
    final barWidth = barSlotWidth * 0.5;
    final minBarHeight = size.height * _minBarHeightFraction;

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final fraction = maxUnitPrice <= 0
          ? 0.0
          : (point.unitPrice / maxUnitPrice).clamp(0.0, 1.0);
      final rawHeight = size.height * fraction;
      final barHeight = point.hasData
          ? (rawHeight < minBarHeight ? minBarHeight : rawHeight)
          : minBarHeight;

      final slotCenter = barSlotWidth * i + barSlotWidth / 2;
      final rect = Rect.fromLTWH(
        slotCenter - barWidth / 2,
        size.height - barHeight,
        barWidth,
        barHeight,
      );
      final rrect = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(_barCornerRadius),
      );

      if (point.hasData) {
        final paint = Paint()
          ..color = barColor
          ..style = PaintingStyle.fill;
        canvas.drawRRect(rrect, paint);
      } else {
        final borderPaint = Paint()
          ..color = emptyBarBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = _barBorderWidth;
        canvas.drawRRect(
          rrect.deflate(_barBorderWidth / 2),
          borderPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PriceHistoryBarPainter oldDelegate) {
    if (oldDelegate.maxUnitPrice != maxUnitPrice ||
        oldDelegate.barColor != barColor ||
        oldDelegate.emptyBarBorderColor != emptyBarBorderColor ||
        oldDelegate.points.length != points.length) {
      return true;
    }
    for (var i = 0; i < points.length; i++) {
      final a = points[i];
      final b = oldDelegate.points[i];
      if (a.hasData != b.hasData ||
          a.unitPrice != b.unitPrice ||
          a.periodStart != b.periodStart) {
        return true;
      }
    }
    return false;
  }
}

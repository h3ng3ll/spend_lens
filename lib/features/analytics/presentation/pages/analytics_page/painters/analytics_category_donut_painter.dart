import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Paints the Analytics category donut (`SpendLens Prototype.dc.html`'s
/// `donut` — a 112px `conic-gradient` ring with a 78px `--card-solid` hole).
///
/// One arc per slice, laid out clockwise from 12 o'clock, sized by the
/// slice's share of the total. The SELECTED slice paints at full color and
/// every other slice at [unselectedOpacity] — the prototype's `hexA(col,
/// '66')` alpha, which is what makes the centre readout's category legible
/// as "the highlighted one" rather than a value with no referent.
///
/// The ring is stroked, not filled: a stroke of [ringThickness] whose path
/// radius is inset by half that thickness reproduces the CSS hole exactly,
/// and leaves the card background showing through the middle so the centre
/// text needs no opaque plate of its own.
///
/// Zero-share slices are SKIPPED rather than drawn at zero width. Sweeping
/// an arc of 0 rad still paints a visible butt-capped tick, which would
/// read as a real measurement — the same class of defect as the recorded
/// chronic bug `chart-zero-value-bar-paints-the-data-fill-so-empty-reads-as
/// -measured` in the sibling bar painter.
class AnalyticsCategoryDonutPainter extends CustomPainter {
  /// Share of the total per slice, each 0.0–1.0, in legend order.
  final List<double> shares;

  /// One color per slice, parallel to [shares].
  final List<Color> colors;

  /// Index into [shares] painted at full opacity.
  final int selectedIndex;

  final double ringThickness;
  final double unselectedOpacity;

  const AnalyticsCategoryDonutPainter({
    required this.shares,
    required this.colors,
    required this.selectedIndex,
    required this.ringThickness,
    required this.unselectedOpacity,
  });

  /// 12 o'clock. Canvas angles start at 3 o'clock, so the ring is rotated
  /// back a quarter turn to match the design's first slice.
  static const double _startAngle = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    if (shares.isEmpty) return;

    final radius = (math.min(size.width, size.height) - ringThickness) / 2;
    if (radius <= 0) return;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    var startAngle = _startAngle;
    for (var i = 0; i < shares.length; i++) {
      final share = shares[i].clamp(0.0, 1.0);
      final sweep = share * 2 * math.pi;
      if (sweep <= 0) continue;

      final color = i < colors.length ? colors[i] : colors.last;
      final paint = Paint()
        ..color = i == selectedIndex
            ? color
            : color.withValues(alpha: unselectedOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = ringThickness;

      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant AnalyticsCategoryDonutPainter oldDelegate) {
    if (oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.ringThickness != ringThickness ||
        oldDelegate.unselectedOpacity != unselectedOpacity ||
        oldDelegate.shares.length != shares.length ||
        oldDelegate.colors.length != colors.length) {
      return true;
    }
    for (var i = 0; i < shares.length; i++) {
      if (oldDelegate.shares[i] != shares[i]) return true;
    }
    for (var i = 0; i < colors.length; i++) {
      if (oldDelegate.colors[i] != colors[i]) return true;
    }
    return false;
  }
}

import 'package:flutter/material.dart';

/// Paints four L-shaped corner brackets framing the receipt-detection area
/// (`SpendLens.dc.html`'s `corners()` component). Own file, per the
/// project's painter-separation rule.
///
/// The brackets hug the painter's OWN box, not a hardcoded screen inset:
/// the painter is sized to the user-configurable scan window by
/// [ScannerFrameArea], so a frame the user narrows or drags carries its
/// corners with it. The `_horizontalInset`/`_verticalInset` constants this
/// once used assumed the painter covered the whole screen and left the
/// brackets stranded mid-preview once the window became movable.
class ScannerCornerPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final double strokeWidth;

  const ScannerCornerPainter({
    required this.color,
    required this.opacity,
    required this.strokeWidth,
  });

  static const _cornerLength = 34.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Inset by half the stroke so the bracket's painted width sits INSIDE
    // the window rather than straddling its edge — a stroke centred on the
    // boundary would spill into the dimmed area and read as a blurred edge.
    final rect = Rect.fromLTWH(
      strokeWidth / 2.0,
      strokeWidth / 2.0,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    // A window narrower than two brackets would draw them crossing over
    // each other; clamping keeps each arm at most half the shorter side.
    final cornerLength = _cornerLength.clamp(
      0.0,
      (rect.shortestSide / 2.0).clamp(0.0, _cornerLength),
    );

    void drawCorner(Offset corner, Offset toH, Offset toV) {
      canvas.drawLine(corner, toH, paint);
      canvas.drawLine(corner, toV, paint);
    }

    // Top-left
    drawCorner(
      rect.topLeft,
      rect.topLeft + Offset(cornerLength, 0),
      rect.topLeft + Offset(0, cornerLength),
    );
    // Top-right
    drawCorner(
      rect.topRight,
      rect.topRight + Offset(-cornerLength, 0),
      rect.topRight + Offset(0, cornerLength),
    );
    // Bottom-left
    drawCorner(
      rect.bottomLeft,
      rect.bottomLeft + Offset(cornerLength, 0),
      rect.bottomLeft + Offset(0, -cornerLength),
    );
    // Bottom-right
    drawCorner(
      rect.bottomRight,
      rect.bottomRight + Offset(-cornerLength, 0),
      rect.bottomRight + Offset(0, -cornerLength),
    );
  }

  @override
  bool shouldRepaint(covariant ScannerCornerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.opacity != opacity ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

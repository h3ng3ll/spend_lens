import 'package:flutter/material.dart';

/// Darkens everything OUTSIDE the scan window, so only the framed rectangle
/// shows live camera. Painted as a single even-odd path (full canvas minus
/// the window) rather than four edge rectangles: four rects leave hairline
/// seams at their shared borders on fractional device pixels, and the
/// even-odd fill is one anti-aliased shape with no seam to leak through.
///
/// Own file, per the project's painter-separation rule.
class ScannerFrameDimPainter extends CustomPainter {
  final Rect window;
  final double borderRadius;
  final Color dimColor;

  const ScannerFrameDimPainter({
    required this.window,
    required this.borderRadius,
    required this.dimColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndRadius(window, Radius.circular(borderRadius)),
      );

    canvas.drawPath(path, Paint()..color = dimColor);
  }

  @override
  bool shouldRepaint(covariant ScannerFrameDimPainter oldDelegate) {
    return oldDelegate.window != window ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.dimColor != dimColor;
  }
}

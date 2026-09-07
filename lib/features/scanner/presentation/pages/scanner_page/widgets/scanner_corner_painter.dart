import 'package:flutter/material.dart';

/// Paints four L-shaped corner brackets framing the receipt-detection area
/// (`SpendLens.dc.html`'s `corners()` component). Own file, per the
/// project's painter-separation rule.
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
  static const _horizontalInset = 44.0;
  static const _verticalInset = 170.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTRB(
      _horizontalInset,
      _verticalInset,
      size.width - _horizontalInset,
      size.height - _verticalInset,
    );

    void drawCorner(Offset corner, Offset toH, Offset toV) {
      canvas.drawLine(corner, toH, paint);
      canvas.drawLine(corner, toV, paint);
    }

    // Top-left
    drawCorner(
      rect.topLeft,
      rect.topLeft + const Offset(_cornerLength, 0),
      rect.topLeft + const Offset(0, _cornerLength),
    );
    // Top-right
    drawCorner(
      rect.topRight,
      rect.topRight + const Offset(-_cornerLength, 0),
      rect.topRight + const Offset(0, _cornerLength),
    );
    // Bottom-left
    drawCorner(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(_cornerLength, 0),
      rect.bottomLeft + const Offset(0, -_cornerLength),
    );
    // Bottom-right
    drawCorner(
      rect.bottomRight,
      rect.bottomRight + const Offset(-_cornerLength, 0),
      rect.bottomRight + const Offset(0, -_cornerLength),
    );
  }

  @override
  bool shouldRepaint(covariant ScannerCornerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.opacity != opacity ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart' show Rect;

/// Detects the receipt's bounding rectangle within a camera frame or a
/// captured still image.
///
/// design_spendlens.md §6/§24: **detection failure never blocks OCR** — a
/// `null` result is a legitimate outcome, and callers must proceed with OCR
/// on the original, uncropped image rather than treating a missing
/// detection as an error.
abstract interface class IReceiptDetector {
  /// Returns the detected receipt rectangle in the image's own coordinate
  /// space, or `null` when no receipt-shaped rectangle was found.
  Future<Rect?> detectReceiptRect(Uint8List imageBytes);

  /// Perspective-corrects [imageBytes] using [rect] (as returned by
  /// [detectReceiptRect]) and returns the cropped, corrected image bytes.
  Future<Uint8List> cropPerspective(Uint8List imageBytes, Rect rect);
}

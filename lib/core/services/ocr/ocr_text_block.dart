import 'package:flutter/material.dart' show Rect;

/// A single recognized line/block of text plus its bounding box.
///
/// Bounding boxes are REQUIRED (design_spendlens.md §6 / §27) — the parser's
/// line-grouping and two-column-detection stages need geometry, so OCR
/// output must never be collapsed to a single `String`. [confidence] is the
/// platform recognizer's own per-block score, forwarded unchanged so the
/// parser (M8) can flag low-confidence lines rather than silently trusting
/// noisy OCR.
class OcrTextBlock {
  final String text;
  final Rect boundingBox;
  final double confidence;

  const OcrTextBlock({
    required this.text,
    required this.boundingBox,
    required this.confidence,
  });
}

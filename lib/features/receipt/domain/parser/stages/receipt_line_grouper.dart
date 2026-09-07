import 'package:flutter/material.dart' show Rect;

import '../../../../../core/services/ocr/ocr_text_block.dart';

/// One grouped receipt line, ready for keyword/price/quantity extraction.
///
/// `text` is the concatenation of every block assigned to this line, in
/// left-to-right reading order — this is what makes a two-column layout
/// (product name on the left, price on the right, as two SEPARATE OCR
/// blocks on the same visual row) readable as a single logical line.
class GroupedLine {
  final String text;
  final double averageConfidence;
  final int lineIndex;

  const GroupedLine({
    required this.text,
    required this.averageConfidence,
    required this.lineIndex,
  });
}

/// Parser stage 2 — line grouper (design_spendlens.md §6/§11).
///
/// OCR returns one block per detected text fragment, not per printed line —
/// a two-column receipt row ("MILK 1L" ... "22.90") frequently comes back
/// as two blocks with the same/overlapping vertical position. This stage
/// groups blocks into logical print lines using their bounding-box
/// vertical center, then orders each line's blocks left-to-right by their
/// horizontal position — the exact shape needed for two-column layouts.
///
/// Deterministic, no LLM (spec §33) — pure geometry over the blocks OCR
/// already returned (never a single collapsed `String`, spec §27).
class ReceiptLineGrouper {
  /// Two blocks are on the same printed line when their vertical centers
  /// are within this fraction of the taller block's height — bounded
  /// tolerance rather than a fixed pixel value so it scales with the
  /// receipt photo's resolution.
  static const _sameLineVerticalToleranceFactor = 0.6;

  const ReceiptLineGrouper();

  List<GroupedLine> group(List<OcrTextBlock> blocks) {
    if (blocks.isEmpty) return const [];

    final sortedByTop =
        blocks.toList()..sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    final rows = <List<OcrTextBlock>>[];
    for (final block in sortedByTop) {
      final row = _findRow(rows, block);
      if (row != null) {
        row.add(block);
      } else {
        rows.add([block]);
      }
    }

    final grouped = <GroupedLine>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i]..sort(
        (a, b) => a.boundingBox.left.compareTo(b.boundingBox.left),
      );
      final text = row.map((b) => b.text.trim()).where((t) => t.isNotEmpty).join(' ');
      if (text.isEmpty) continue;

      final averageConfidence =
          row.map((b) => b.confidence).reduce((a, b) => a + b) / row.length;

      grouped.add(
        GroupedLine(
          text: text,
          averageConfidence: averageConfidence,
          lineIndex: i,
        ),
      );
    }
    return grouped;
  }

  List<OcrTextBlock>? _findRow(
    List<List<OcrTextBlock>> rows,
    OcrTextBlock block,
  ) {
    for (final row in rows) {
      final reference = row.first.boundingBox;
      if (_sameRow(reference, block.boundingBox)) return row;
    }
    return null;
  }

  bool _sameRow(Rect a, Rect b) {
    final aCenter = a.top + a.height / 2;
    final bCenter = b.top + b.height / 2;
    final tolerance =
        (a.height > b.height ? a.height : b.height) *
        _sameLineVerticalToleranceFactor;
    return (aCenter - bCenter).abs() <= tolerance;
  }
}

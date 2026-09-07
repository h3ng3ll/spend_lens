import '../models/receipt/receipt.dart';

/// Receipt rule — duplicate detector (design_spendlens.md §6/§46).
///
/// Flags a candidate receipt as a likely duplicate of an already-saved one
/// when the store, purchase date (same calendar day), and total all match
/// closely. It ONLY WARNS and allows the user to continue — it NEVER
/// auto-deletes anything (spec §46). The caller decides what to show and
/// whether the user proceeds; this class only answers "is this a likely
/// duplicate", never acts on the answer.
class ReceiptDuplicateDetector {
  static const _totalMatchTolerance = 0.02;

  const ReceiptDuplicateDetector();

  /// Returns the existing receipt this candidate most likely duplicates, or
  /// `null` if none of [existingReceipts] look like a match.
  Receipt? findLikelyDuplicate({
    required String? storeId,
    required DateTime purchasedAt,
    required double total,
    required List<Receipt> existingReceipts,
  }) {
    for (final existing in existingReceipts) {
      if (existing.deletedAt != null) continue;
      if (storeId != null && existing.storeId != storeId) continue;
      if (!_isSameDay(existing.purchasedAt, purchasedAt)) continue;

      final existingTotal = existing.printedTotal ?? existing.itemsTotal;
      if ((existingTotal - total).abs() > _totalMatchTolerance) continue;

      return existing;
    }
    return null;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

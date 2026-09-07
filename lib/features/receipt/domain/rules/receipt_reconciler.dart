/// Result of comparing a receipt's printed total against the sum of its
/// item lines (design_spendlens.md §6/§45).
class ReconciliationResult {
  final bool matches;
  final double? printedTotal;
  final double itemsTotal;
  final double difference;

  const ReconciliationResult({
    required this.matches,
    required this.printedTotal,
    required this.itemsTotal,
    required this.difference,
  });
}

/// Receipt rule — reconciler (design_spendlens.md §6/§45).
///
/// Compares the parser's printed total against the sum of the item lines
/// and reports a mismatch. It ONLY WARNS: `Receipt.isReconciled` reflects
/// whether the user has acknowledged a mismatch, but saving is ALWAYS
/// allowed regardless of the reconciliation outcome (spec §45) — this class
/// never blocks a save, it only informs the UI what to show.
class ReceiptReconciler {
  /// Amounts within this many currency units are treated as matching —
  /// rounding noise from unit-price arithmetic (e.g. weighed lines) can
  /// legitimately differ by a cent or two from the printed total.
  static const _matchTolerance = 0.02;

  const ReceiptReconciler();

  ReconciliationResult reconcile({
    required double? printedTotal,
    required double itemsTotal,
  }) {
    if (printedTotal == null) {
      // No printed total was found at all — nothing to compare against,
      // so this is reported as a (harmless) non-match with a zero
      // difference; the UI copy for "no printed total" is distinct from
      // "mismatch found" and is the caller's concern, not this class's.
      return ReconciliationResult(
        matches: true,
        printedTotal: null,
        itemsTotal: itemsTotal,
        difference: 0.0,
      );
    }

    final difference = (printedTotal - itemsTotal).abs();
    return ReconciliationResult(
      matches: difference <= _matchTolerance,
      printedTotal: printedTotal,
      itemsTotal: itemsTotal,
      difference: difference,
    );
  }
}

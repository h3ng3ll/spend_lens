import '../../../product/domain/models/product/e_unit.dart';

/// One product line candidate produced by the parser pipeline
/// (design_spendlens.md §6 — the product-candidate-builder stage's output).
///
/// This is a pure parser-domain value — never a [ReceiptItem]. The scanner
/// pipeline / a use case maps it to a [ReceiptItem] once the normalizer has
/// resolved `rawName` to a `Product` match (or created one).
class ParsedLineCandidate {
  /// The literal OCR text this candidate was built from — becomes
  /// `ReceiptItem.rawName` and must never be altered afterwards (spec §11).
  final String rawName;
  final double quantity;
  final EUnit unit;
  final double? unitPrice;
  final double lineTotal;

  /// Parser confidence in [0, 1] for this line's extraction — lower when the
  /// price/quantity extraction had to guess (e.g. no explicit `@` unit
  /// price, or a low-confidence OCR block).
  final double confidence;

  /// Position on the receipt, preserving print order.
  final int lineIndex;

  const ParsedLineCandidate({
    required this.rawName,
    required this.quantity,
    required this.unit,
    this.unitPrice,
    required this.lineTotal,
    required this.confidence,
    required this.lineIndex,
  });
}

/// The parser pipeline's complete output (design_spendlens.md §6).
///
/// `total` is `null` when no total keyword line was found — the caller
/// (reconciler / Review screen) must treat a null total as "OCR found no
/// printed total", never as zero (spec §35 — never inferred from "the
/// largest or last number").
class ParsedReceipt {
  /// The store name as PRINTED on the receipt — raw OCR text. Never
  /// overwritten by a user's store pick, because price history keys off the
  /// literal printed text (spec §11).
  final String? storeName;

  /// The RESOLVED store this receipt belongs to, or null when nothing
  /// matched. Distinct from [storeName]: that is what the paper said, this
  /// is which `Store` row it maps to.
  ///
  /// Before this field existed, a store picked in "Correct receipt" was
  /// dropped on the way back to Review — the draft carried only the printed
  /// name, so the choice had nowhere to live and every scanned receipt
  /// saved with no store at all.
  final String? storeId;

  /// Whether [storeId] was chosen by the USER rather than auto-matched.
  /// Gates alias learning: an auto-match must never teach itself its own
  /// alias, or one bad match becomes permanent.
  final bool isStoreUserPicked;

  final DateTime? purchasedAt;
  final double? total;
  final double? discount;
  final List<ParsedLineCandidate> items;

  const ParsedReceipt({
    this.storeName,
    this.storeId,
    this.isStoreUserPicked = false,
    this.purchasedAt,
    this.total,
    this.discount,
    required this.items,
  });

  /// Whether the parser produced anything usable at all. An empty result
  /// (no items AND no total) is what drives the scan-failed state — never a
  /// generic "something went wrong" (design_spendlens.md §8/§66).
  bool get isUnusable => items.isEmpty && total == null;

  double get itemsTotal =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);
}

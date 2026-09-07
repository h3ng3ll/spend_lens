/// What a grouped receipt line semantically represents, per its printed
/// keyword — design_spendlens.md §6/§35: the total is found by matching
/// PRINTED KEYWORDS, never by picking "the largest or last number" on the
/// receipt (a barcode's digit string is very often larger than the total).
enum EReceiptLineKind { total, discount, itemCandidate }

/// Parser stage 3 — keyword detector (design_spendlens.md §6/§35).
///
/// This table holds ONLY what is PRINTED ON PAPER by Moldovan/Romanian
/// point-of-sale systems — it must never be merged with the UI-label
/// vocabulary in the ARB files (spec §4.4: ARB holds `Bon`/`Reducere`/
/// `Cant.`/`Sumă` for the app's OWN chrome; this table holds what a printer
/// puts on a receipt, which is a fixed, non-localized vocabulary because
/// the receipt itself was never localized to the app's display language).
///
/// Deterministic, no LLM (spec §33) — a case-insensitive substring match
/// over a fixed keyword list.
class ReceiptKeywordDetector {
  /// The 5 total keywords this milestone is verified against (spec §11):
  /// `TOTAL DE PLATA`, `SUMA DE PLATA`, `TOTAL GENERAL`, `SUMA`, `TOTAL`.
  /// Ordered longest-first so a more specific phrase is preferred over a
  /// shorter one that is also a substring of it (e.g. `TOTAL` alone must
  /// not steal a `TOTAL DE PLATA` line's classification before the more
  /// specific phrase gets a chance — though because this is a
  /// containment check, not a first-match-wins scan, order does not
  /// actually change the OUTCOME here; it is kept for readability and in
  /// case a future keyword is a true prefix of another).
  static const totalKeywords = <String>[
    'TOTAL DE PLATA',
    'SUMA DE PLATA',
    'TOTAL GENERAL',
    'SUMA',
    'TOTAL',
  ];

  static const discountKeywords = <String>[
    'REDUCERE',
    'DISCOUNT',
    'DISCONT',
  ];

  const ReceiptKeywordDetector();

  EReceiptLineKind classify(String line) {
    final upper = line.toUpperCase();
    if (totalKeywords.any(upper.contains)) return EReceiptLineKind.total;
    if (discountKeywords.any(upper.contains)) {
      return EReceiptLineKind.discount;
    }
    return EReceiptLineKind.itemCandidate;
  }
}

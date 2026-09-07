/// Normalizer stage 1 — cleanup (design_spendlens.md §6).
///
/// Lowercases, collapses whitespace, and strips punctuation noise from a
/// raw OCR product name so the later matching stages compare like-for-like
/// — this NEVER touches `ReceiptItem.rawName` itself (spec §11); it only
/// produces the `normalizedName` candidate string.
///
/// Deterministic, no LLM (spec §33).
class ProductNameCleaner {
  const ProductNameCleaner();

  String clean(String rawName) {
    var cleaned = rawName.toLowerCase();
    cleaned = cleaned.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned;
  }
}

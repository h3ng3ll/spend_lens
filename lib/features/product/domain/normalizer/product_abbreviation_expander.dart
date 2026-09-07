/// Normalizer stage 2 — abbreviation expansion (design_spendlens.md §6).
///
/// Moldovan/Romanian point-of-sale printers abbreviate common product-name
/// words to fit the receipt's narrow column width. This table expands the
/// abbreviations BEFORE matching so `"FRANZ GRIU"` and `"FRANZELA DE GRIU"`
/// normalize to the same candidate string.
///
/// This is a DIFFERENT vocabulary from the parser's total/discount keyword
/// table (`ReceiptKeywordDetector`) and from the app's own ARB UI labels —
/// this one is specifically abbreviations found INSIDE printed product
/// names, never merged with either of the other two (spec §4.4).
///
/// Deterministic, no LLM (spec §33) — operates on already-lowercased,
/// whitespace-collapsed text (i.e. after [ProductNameCleaner]).
class ProductAbbreviationExpander {
  static const _expansions = <String, String>{
    'franz': 'franzela',
    'lgm': 'lapte',
    'lact': 'lactate',
    'pn': 'paine',
    'past': 'paste',
    'ulei': 'ulei',
    'zah': 'zahar',
    'ciocl': 'ciocolata',
  };

  const ProductAbbreviationExpander();

  String expand(String cleanedName) {
    final words = cleanedName.split(' ');
    final expanded = words.map((word) => _expansions[word] ?? word);
    return expanded.join(' ');
  }
}

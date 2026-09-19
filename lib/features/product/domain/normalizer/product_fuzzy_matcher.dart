/// Normalizer stage 4 — fuzzy match (design_spendlens.md §6/§42).
///
/// Uses a normalized Levenshtein similarity to find the closest EXISTING
/// candidate name, but is deliberately CONSERVATIVE (spec §42): only a very
/// close near-miss (single-character OCR noise) counts as a match. A
/// genuine near-miss that is not close enough returns `null` so the caller
/// creates a new product — false merges are worse than duplicates.
///
/// Deterministic, no LLM (spec §33) — pure string-distance arithmetic.
class ProductFuzzyMatcher {
  /// Minimum similarity ratio (`1 - editDistance/maxLength`) for two names
  /// to be considered the same product. Deliberately high — this is what
  /// makes the matcher conservative: a similarity BELOW this threshold
  /// always creates a new product rather than merging.
  static const _similarityThreshold = 0.86;

  const ProductFuzzyMatcher();

  /// Returns the closest candidate from [existingNormalizedNames] if its
  /// similarity to [name] clears the threshold, else `null`.
  ///
  /// [minSimilarity] defaults to [_similarityThreshold], so product
  /// normalization behaves exactly as before. It is overridable for
  /// non-product callers with a different tolerance for a false merge —
  /// `ReceiptStoreMatcher` passes a far looser value, because a receipt
  /// header carries legal-entity noise ("KAUFLAND SA MD-2001") that a store
  /// name never has, and merging onto the wrong store there is recoverable
  /// while merging two products corrupts price history.
  String? findClosestMatch(
    String name,
    List<String> existingNormalizedNames, {
    double minSimilarity = _similarityThreshold,
  }) {
    String? best;
    double bestSimilarity = 0.0;

    for (final candidate in existingNormalizedNames) {
      final similarity = _similarity(name, candidate);
      if (similarity > bestSimilarity) {
        bestSimilarity = similarity;
        best = candidate;
      }
    }

    if (best != null && bestSimilarity >= minSimilarity) return best;
    return null;
  }

  double _similarity(String a, String b) {
    if (a == b) return 1.0;
    final maxLength = a.length > b.length ? a.length : b.length;
    if (maxLength == 0) return 1.0;
    final distance = _levenshteinDistance(a, b);
    return 1.0 - (distance / maxLength);
  }

  int _levenshteinDistance(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    var previousRow = List<int>.generate(b.length + 1, (i) => i);
    for (var i = 0; i < a.length; i++) {
      final currentRow = List<int>.filled(b.length + 1, 0);
      currentRow[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final deletionCost = previousRow[j + 1] + 1;
        final insertionCost = currentRow[j] + 1;
        final substitutionCost = previousRow[j] + (a[i] == b[j] ? 0 : 1);
        currentRow[j + 1] = [
          deletionCost,
          insertionCost,
          substitutionCost,
        ].reduce((v, e) => v < e ? v : e);
      }
      previousRow = currentRow;
    }
    return previousRow[b.length];
  }
}

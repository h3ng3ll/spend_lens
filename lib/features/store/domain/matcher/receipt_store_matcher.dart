import '../../../product/domain/normalizer/product_fuzzy_matcher.dart';
import '../../../product/domain/normalizer/product_name_cleaner.dart';
import '../models/store/store.dart';

/// Matches a receipt's PRINTED store name against the stores that already
/// exist, and returns `null` when none is a credible match.
///
/// **Why this exists.** `ReceiptStoreResolver` (the parser stage) extracts the
/// header string and says so itself: *"This stage does NOT try to match against
/// the `Store` Hive collection (that is a repository-layer concern the use case
/// above the parser performs)"*. That use case was never written, so a scanned
/// receipt reached the save path with a store NAME and no store, and was
/// persisted with `storeId: null` — invisible on every per-store screen.
///
/// **It never creates a store.** This is the one hard rule. A receipt whose
/// header matches nothing leaves the field unselected for the user to fill,
/// because inventing a store from OCR text is how a catalogue fills with
/// near-duplicate junk that nobody can merge afterwards. That mirrors
/// `ProductNormalizer`'s conservatism — *"false merges are worse than
/// duplicates"* — with its final stage INVERTED: products create on a miss,
/// stores do not.
///
/// Deterministic, no LLM (spec §33) — pure string arithmetic, so the same
/// receipt always resolves the same way.
class ReceiptStoreMatcher {
  final ProductNameCleaner _cleaner;
  final ProductFuzzyMatcher _fuzzyMatcher;

  const ReceiptStoreMatcher({
    ProductNameCleaner cleaner = const ProductNameCleaner(),
    ProductFuzzyMatcher fuzzyMatcher = const ProductFuzzyMatcher(),
  }) : this._(cleaner, fuzzyMatcher);

  const ReceiptStoreMatcher._(this._cleaner, this._fuzzyMatcher);

  /// Shortest cleaned string allowed to match by CONTAINMENT.
  ///
  /// Without a floor, a two-letter store name is a substring of almost every
  /// receipt header, so every scan would resolve to it.
  static const _minContainmentLength = 4;

  /// Lowest similarity that still counts as the same store.
  ///
  /// Far below `ProductFuzzyMatcher`'s 0.86, and deliberately so: a receipt
  /// header carries legal-entity noise the store name never has
  /// (`"KAUFLAND SA MD-2001"` vs `"Kaufland"`), which inflates edit distance
  /// even on a certain match. The containment stage below catches those cases,
  /// so this threshold is only the last line against a clearly-unrelated name —
  /// `"LINELLA"` scores ~0.12 against `"Kaufland"` and is correctly rejected.
  static const _minSimilarity = 0.2;

  /// The best existing match for [printedName], or `null` when nothing is
  /// close enough.
  ///
  /// Stages run in order and the first hit wins, most-certain first: an alias
  /// the user taught us, then an exact name, then containment, then fuzzy.
  Store? match({required String? printedName, required List<Store> stores}) {
    if (printedName == null) return null;

    final cleaned = _cleaner.clean(printedName);
    if (cleaned.isEmpty) return null;

    final ordered = _ordered(stores);

    // 1. ALIAS — an exact spelling the user has already confirmed for this
    // store. The strongest signal available, because it came from a human
    // rather than from arithmetic, so it outranks even an exact name match.
    for (final store in ordered) {
      for (final alias in store.receiptAliases) {
        if (_cleaner.clean(alias) == cleaned) return store;
      }
    }

    // 2. EXACT NAME.
    for (final store in ordered) {
      if (_cleaner.clean(store.name) == cleaned) return store;
    }

    // 3. CONTAINMENT — either string inside the other. This is the stage that
    // actually resolves real receipts: headers routinely append a legal form,
    // a branch, or an address fragment to the brand name.
    Store? bestContained;
    var bestContainedLength = 0;
    for (final store in ordered) {
      final name = _cleaner.clean(store.name);
      if (name.length < _minContainmentLength) continue;
      if (!cleaned.contains(name) && !name.contains(cleaned)) continue;

      // The LONGEST matched name wins: when both "nr1" and "nr1 green hills"
      // are contained, the more specific one is the better answer.
      if (name.length > bestContainedLength) {
        bestContainedLength = name.length;
        bestContained = store;
      }
    }
    if (bestContained != null) return bestContained;

    // 4. FUZZY — OCR noise on an otherwise-equal name ("KAUFLNAD"). Scored
    // across every store's name AND aliases, so a misread of a learned
    // spelling still resolves.
    final candidates = <String, Store>{};
    for (final store in ordered) {
      for (final candidate in [store.name, ...store.receiptAliases]) {
        final key = _cleaner.clean(candidate);
        // `putIfAbsent`: two stores sharing a spelling resolve to the first in
        // id order rather than to whichever the map happened to write last.
        if (key.isNotEmpty) candidates.putIfAbsent(key, () => store);
      }
    }

    final closest = _fuzzyMatcher.findClosestMatch(
      cleaned,
      candidates.keys.toList(),
      minSimilarity: _minSimilarity,
    );
    if (closest == null) return null;

    return candidates[closest];
  }

  /// Stores in a STABLE order, so a tie never depends on box iteration order —
  /// the same receipt must resolve to the same store on every device.
  List<Store> _ordered(List<Store> stores) {
    final ordered = [...stores];
    ordered.sort((a, b) => a.id.compareTo(b.id));
    return ordered;
  }
}

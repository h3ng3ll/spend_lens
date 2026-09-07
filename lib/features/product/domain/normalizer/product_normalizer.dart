import '../../../../core/models/e_sync_status.dart';
import '../models/product/e_unit.dart';
import '../models/product/product.dart';
import 'product_abbreviation_expander.dart';
import 'product_fuzzy_matcher.dart';
import 'product_match_result.dart';
import 'product_name_cleaner.dart';

/// Function that produces a new unique id for a created [Product] — kept
/// injectable so tests can supply a deterministic sequence rather than a
/// real uuid generator, and so this pure-domain class needs no `uuid`
/// package dependency of its own.
typedef ProductIdGenerator = String Function();

/// The full normalizer pipeline (design_spendlens.md §6/§11/§42):
/// cleanup -> abbreviation expansion -> exact match -> fuzzy match -> create
/// new.
///
/// CONSERVATIVE by design (spec §42): a near-miss that does not clear the
/// fuzzy matcher's high similarity threshold CREATES a new product rather
/// than merging into an existing one, because false merges are worse than
/// duplicates. This class NEVER touches `ReceiptItem.rawName` — it only
/// ever produces/matches a [Product]; the caller is responsible for setting
/// `ReceiptItem.normalizedName`/`productId` from the result, never
/// `rawName` (spec §11, the hardest invariant).
///
/// Deterministic, no LLM (spec §33).
class ProductNormalizer {
  final ProductNameCleaner _cleaner;
  final ProductAbbreviationExpander _abbreviationExpander;
  final ProductFuzzyMatcher _fuzzyMatcher;
  final DateTime Function() _now;

  const ProductNormalizer({
    this._cleaner = const ProductNameCleaner(),
    this._abbreviationExpander = const ProductAbbreviationExpander(),
    this._fuzzyMatcher = const ProductFuzzyMatcher(),
    this._now = DateTime.now,
  });

  /// Normalizes [rawName] against [existingProducts], creating a new
  /// [Product] via [generateId] when neither an exact nor a sufficiently
  /// close fuzzy match exists.
  ProductMatchResult normalize({
    required String rawName,
    required List<Product> existingProducts,
    required ProductIdGenerator generateId,
    EUnit defaultUnit = EUnit.piece,
  }) {
    // Stage 1 — cleanup.
    final cleaned = _cleaner.clean(rawName);

    // Stage 2 — abbreviation expansion.
    final expanded = _abbreviationExpander.expand(cleaned);

    // Stage 3 — exact match (against normalizedName AND every alias).
    for (final product in existingProducts) {
      if (product.normalizedName == expanded || product.aliases.contains(expanded)) {
        return ProductMatchResult(
          product: product,
          outcome: ENormalizerOutcome.exactMatch,
        );
      }
    }

    // Stage 4 — fuzzy match, conservative threshold (spec §42).
    final existingNames = existingProducts.map((p) => p.normalizedName).toList();
    final closest = _fuzzyMatcher.findClosestMatch(expanded, existingNames);
    if (closest != null) {
      final matched = existingProducts.firstWhere(
        (p) => p.normalizedName == closest,
      );
      return ProductMatchResult(
        product: matched,
        outcome: ENormalizerOutcome.fuzzyMatch,
      );
    }

    // Stage 5 — create new. A near-miss that did not clear the fuzzy
    // threshold lands HERE, deliberately — see spec §42.
    final created = Product(
      id: generateId(),
      normalizedName: expanded,
      displayName: rawName.trim(),
      defaultUnit: defaultUnit,
      updatedAt: _now(),
      syncStatus: ESyncStatus.pendingCreate,
    );
    return ProductMatchResult(
      product: created,
      outcome: ENormalizerOutcome.created,
    );
  }
}

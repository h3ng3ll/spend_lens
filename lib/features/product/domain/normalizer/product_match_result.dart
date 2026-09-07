import '../models/product/product.dart';

/// What the normalizer decided for one candidate raw name
/// (design_spendlens.md §6/§42).
enum ENormalizerOutcome { exactMatch, fuzzyMatch, created }

/// The normalizer's decision for one receipt line's raw name — either an
/// existing [Product] it matched to (exact or fuzzy) or a brand-new one it
/// had to create (spec §42: CONSERVATIVE — a near-miss creates rather than
/// merges, because false merges are worse than duplicates).
class ProductMatchResult {
  final Product product;
  final ENormalizerOutcome outcome;

  const ProductMatchResult({required this.product, required this.outcome});

  bool get isNewProduct => outcome == ENormalizerOutcome.created;
}

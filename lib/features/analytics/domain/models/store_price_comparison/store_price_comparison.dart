/// One product row's cross-store comparison result (design's Stores-detail
/// artboard, `SpendLens Prototype.dc.html` line 885 —
/// `p.better === true|false|null`). ARB-key-driven, never a rendered
/// string: [key] resolves to `cheaperBy` / `cheapestOf` / `onlyHere`.
///
/// [isBetterHere] mirrors the design's tri-state `better` field exactly:
/// - `true` — this store is the cheapest across all stores this product was
///   bought at (`cheapestOf` when 3+ stores, `cheaperBy` phrasing when
///   there is exactly one cheaper alternative to name).
/// - `false` — a cheaper alternative exists elsewhere (`cheaperBy`).
/// - `null` — this product has only ever been bought at this one store
///   (`onlyHere`) — there is nothing to compare against.
enum EStorePriceComparisonKey { cheaperBy, cheapestOf, onlyHere }

class StorePriceComparison {
  final String productId;
  final EStorePriceComparisonKey key;

  /// true = this store is cheapest, false = a cheaper store exists,
  /// null = only ever bought here (nothing to compare).
  final bool? isBetterHere;

  /// Positional params for [key]'s ARB template, in template order.
  final List<Object> params;

  const StorePriceComparison({
    required this.productId,
    required this.key,
    required this.isBetterHere,
    required this.params,
  });
}

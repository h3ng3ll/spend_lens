/// Cross-store price comparison for the Stores-detail "Products bought
/// here" list (design's Stores-detail artboard comparison lines; spec
/// §54–57's "Both" resolution — design_spendlens.md's Conflicts table).
/// Pure function; emits (ARB key, params) pairs, never rendered strings —
/// same discipline as the insight generator.
///
/// Currency is a DISPLAY LABEL and is deliberately NOT a parameter here:
/// every observation for the product enters the comparison regardless of
/// the code it was stored with, and prices are never converted. Filtering
/// on a stored code made comparison rows disappear whenever the user's
/// setting differed from it — the same defect that zeroed Analytics.
///
/// COMPARISON RUNS OVER A SET OF PRODUCT IDS, not one. Products are
/// per-store, so the same goods at two stores are two rows with two ids;
/// grouping on a single id would make every row report "Only bought here"
/// and silently retire this whole feature. The set is the user's manual link
/// group, resolved by `resolveLinkedGroup` — an unlinked product simply
/// passes a set of one and behaves exactly as before.
library;

import '../../../store/domain/models/store/store.dart';
import '../models/price_observation/price_observation.dart';
import '../models/store_price_comparison/store_price_comparison.dart';

/// Builds the [StorePriceComparison] for [productId] as bought at
/// [atStoreId], across every observation belonging to
/// [comparableProductIds].
///
/// [comparableProductIds] is [productId] plus the products the user has
/// linked it to at other stores. It must CONTAIN [productId]; pass
/// `{productId}` for an unlinked product. The result still reports
/// [productId], because that is the row being rendered — the set only widens
/// what it is measured against.
///
/// Returns null when there is no observation for this product at
/// [atStoreId] — nothing to show a comparison row for.
StorePriceComparison? compareStorePriceForProduct({
  required String productId,
  required String atStoreId,
  required List<PriceObservation> allObservations,
  required List<Store> stores,
  Set<String>? comparableProductIds,
}) {
  final comparableIds = comparableProductIds ?? {productId};

  final productObservations = allObservations
      .where(
        (observation) =>
            comparableIds.contains(observation.productId) &&
            observation.deletedAt == null &&
            observation.storeId != null,
      )
      .toList();

  final atStoreObservations = productObservations
      .where((o) => o.storeId == atStoreId)
      .toList();
  if (atStoreObservations.isEmpty) {
    return null;
  }

  // Latest observed price at this store. With a link group, more than one
  // product in the set can have observations here (a linked general-purpose
  // row, say) — taking the most recent across all of them is the right
  // reading: it is the latest price of this thing, at this store.
  atStoreObservations.sort((a, b) => b.observedAt.compareTo(a.observedAt));
  final priceHere = atStoreObservations.first.comparableUnitPrice;

  // Latest price per OTHER store this product was bought at.
  final otherStoreIds = productObservations.map((o) => o.storeId!).toSet()
    ..remove(atStoreId);

  if (otherStoreIds.isEmpty) {
    return StorePriceComparison(
      productId: productId,
      key: EStorePriceComparisonKey.onlyHere,
      isBetterHere: null,
      params: const [],
    );
  }

  final latestPriceByStore = <String, double>{};
  for (final storeId in otherStoreIds) {
    final storeObservations =
        productObservations.where((o) => o.storeId == storeId).toList()
          ..sort((a, b) => b.observedAt.compareTo(a.observedAt));
    latestPriceByStore[storeId] = storeObservations.first.comparableUnitPrice;
  }

  final totalStoreCount = otherStoreIds.length + 1;
  final cheapestOtherEntry = latestPriceByStore.entries.reduce(
    (a, b) => a.value <= b.value ? a : b,
  );

  final isCheapestHere = latestPriceByStore.values.every(
    (price) => priceHere <= price,
  );

  if (isCheapestHere) {
    if (totalStoreCount >= 3) {
      return StorePriceComparison(
        productId: productId,
        key: EStorePriceComparisonKey.cheapestOf,
        isBetterHere: true,
        params: [totalStoreCount],
      );
    }
    // Exactly one alternative store — name it via cheaperBy phrasing with
    // this store as the cheaper reference point.
    final cheaperStoreName = _storeName(stores, cheapestOtherEntry.key) ?? '';
    final difference = cheapestOtherEntry.value - priceHere;
    return StorePriceComparison(
      productId: productId,
      key: EStorePriceComparisonKey.cheaperBy,
      isBetterHere: true,
      params: [
        cheaperStoreName,
        priceHere.round(),
        difference.toStringAsFixed(2),
      ],
    );
  }

  final cheaperStoreName = _storeName(stores, cheapestOtherEntry.key) ?? '';
  final difference = priceHere - cheapestOtherEntry.value;
  return StorePriceComparison(
    productId: productId,
    key: EStorePriceComparisonKey.cheaperBy,
    isBetterHere: false,
    params: [
      cheaperStoreName,
      cheapestOtherEntry.value.round(),
      difference.toStringAsFixed(2),
    ],
  );
}

String? _storeName(List<Store> stores, String storeId) {
  for (final store in stores) {
    if (store.id == storeId) return store.name;
  }
  return null;
}

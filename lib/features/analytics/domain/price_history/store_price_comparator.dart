/// Cross-store price comparison for the Stores-detail "Products bought
/// here" list (design's Stores-detail artboard comparison lines; spec
/// §54–57's "Both" resolution — design_spendlens.md's Conflicts table).
/// Pure function; emits (ARB key, params) pairs, never rendered strings —
/// same discipline as the insight generator.
///
/// Currency guard: only observations in [displayCurrencyCode] are
/// considered; an observation printed in another currency never enters the
/// cheapest-store comparison (spec §52).
library;

import '../../../store/domain/models/store/store.dart';
import '../models/price_observation/price_observation.dart';
import '../models/store_price_comparison/store_price_comparison.dart';

/// Builds the [StorePriceComparison] for [productId] as bought at
/// [atStoreId], across all [allObservations] for that product.
///
/// Returns null when there is no observation for this product at
/// [atStoreId] in [displayCurrencyCode] — nothing to show a comparison row
/// for.
StorePriceComparison? compareStorePriceForProduct({
  required String productId,
  required String atStoreId,
  required List<PriceObservation> allObservations,
  required List<Store> stores,
  required String displayCurrencyCode,
}) {
  final productObservations = allObservations
      .where(
        (observation) =>
            observation.productId == productId &&
            observation.deletedAt == null &&
            observation.currencyCode == displayCurrencyCode &&
            observation.storeId != null,
      )
      .toList();

  final atStoreObservations =
      productObservations.where((o) => o.storeId == atStoreId).toList();
  if (atStoreObservations.isEmpty) {
    return null;
  }

  // Latest observed price at this store.
  atStoreObservations.sort((a, b) => b.observedAt.compareTo(a.observedAt));
  final priceHere = atStoreObservations.first.comparableUnitPrice;

  // Latest price per OTHER store this product was bought at.
  final otherStoreIds =
      productObservations.map((o) => o.storeId!).toSet()..remove(atStoreId);

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
    final storeObservations = productObservations
        .where((o) => o.storeId == storeId)
        .toList()
      ..sort((a, b) => b.observedAt.compareTo(a.observedAt));
    latestPriceByStore[storeId] = storeObservations.first.comparableUnitPrice;
  }

  final totalStoreCount = otherStoreIds.length + 1;
  final cheapestOtherEntry = latestPriceByStore.entries
      .reduce((a, b) => a.value <= b.value ? a : b);

  final isCheapestHere =
      latestPriceByStore.values.every((price) => priceHere <= price);

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
    final cheaperStoreName =
        _storeName(stores, cheapestOtherEntry.key) ?? '';
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

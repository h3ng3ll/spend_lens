/// Pure narrowing functions for the Compare screen.
///
/// Deliberately NOT bloc state (BLoC rule A3.1 — no `filteredX` fields):
/// every list here is recomputed from the snapshot on build, never stored.
library;

import '../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../product/domain/models/product/product.dart';
import '../../../product/presentation/utils/product_price_points.dart';

/// The products belonging to [storeId], by OWNERSHIP.
///
/// The same rule the store-detail list uses — membership is
/// `Product.storeId`, never where a price happened to be observed — so the
/// two screens can never disagree about what a store sells.
List<Product> productsForStore(List<Product> products, String? storeId) {
  if (storeId == null) return const [];
  return products
      .where(
        (product) => product.storeId == storeId && product.deletedAt == null,
      )
      .toList()
    ..sort(
      (a, b) => a.displayName.toLowerCase().compareTo(
            b.displayName.toLowerCase(),
          ),
    );
}

/// The most recent price recorded for [productId] at [storeId], or null when
/// the product has none yet.
///
/// Delegates to `pricePointsForProduct` rather than re-filtering: that
/// function already owns the store-scoping rule and already sorts
/// newest-first, and a second implementation here could drift from the
/// product page's idea of "the latest price".
PriceObservation? latestPriceFor(
  List<PriceObservation> observations,
  String productId, {
  required String? storeId,
}) {
  final points = pricePointsForProduct(
    observations,
    productId,
    storeId: storeId,
  );
  return points.isEmpty ? null : points.first;
}

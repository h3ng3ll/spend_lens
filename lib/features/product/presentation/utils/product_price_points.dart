/// Pure per-product aggregate functions over a `ProductDetailSnapshot`.
///
/// Deliberately NOT bloc state (BLoC rule A3.1 — no `filteredX`/derived
/// fields in state or state-extension getters): everything here is
/// recomputed from the snapshot on every build, never stored.
library;

import '../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../store/domain/models/store/store.dart';

/// This product's live price points AT ITS OWN STORE, newest first.
///
/// SCOPED TO [storeId] — the store the product belongs to. Products are
/// per-store, so a page that listed every observation for the product
/// regardless of where it was seen showed two shops' prices in one list and
/// fed the same mixture to the inflation chart, where a "+23%" rise could be
/// nothing but a switch from a cheap shop to an expensive one.
///
/// A NULL-store observation is always included: it is a price the user typed
/// on this product's own page without naming a shop, and dropping it would
/// mean entering a price and watching it vanish. For a general-purpose
/// product ([storeId] null) that is the whole set, which is also correct.
///
/// Tombstones are excluded with the same predicate every other product
/// surface uses, so the page's list and the store's product count can never
/// disagree about what exists.
List<PriceObservation> pricePointsForProduct(
  List<PriceObservation> observations,
  String productId, {
  required String? storeId,
}) {
  final points = observations
      .where(
        (observation) =>
            observation.productId == productId &&
            observation.deletedAt == null &&
            (observation.storeId == storeId || observation.storeId == null),
      )
      .toList()
    ..sort((a, b) => b.observedAt.compareTo(a.observedAt));
  return points;
}

/// The store's name, or null when [storeId] is null or names a store that no
/// longer exists — a price observed at a since-deleted store still happened,
/// so the row renders without a name rather than disappearing.
String? storeNameFor(List<Store> stores, String? storeId) {
  if (storeId == null) return null;
  for (final store in stores) {
    if (store.id == storeId) return store.name;
  }
  return null;
}

/// Formats an amount for display — two decimals, no grouping, matching
/// `store_aggregates.dart`'s `formatAmount` so the two screens agree.
String formatPrice(double value) => value.toStringAsFixed(2);

import '../models/price_observation/price_observation.dart';

/// The most common currency [productId]'s observations were printed in —
/// resolves the display currency for its price-history chart without ever
/// combining currencies (spec §52, §11 — same "dominant currency" pattern
/// `store_aggregates.dart` uses for a store's totals). Returns an empty
/// string when there are no matching observations, which the calculator
/// then reports as "no data" rather than a fabricated default.
String dominantObservationCurrency(
  List<PriceObservation> observations,
  String productId,
) {
  final counts = <String, int>{};
  for (final observation in observations) {
    if (observation.productId != productId || observation.deletedAt != null) {
      continue;
    }
    counts[observation.currencyCode] =
        (counts[observation.currencyCode] ?? 0) + 1;
  }

  if (counts.isEmpty) return '';

  var bestCode = counts.keys.first;
  var bestCount = 0;
  for (final entry in counts.entries) {
    if (entry.value > bestCount) {
      bestCount = entry.value;
      bestCode = entry.key;
    }
  }
  return bestCode;
}

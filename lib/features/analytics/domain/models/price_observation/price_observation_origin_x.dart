import 'price_observation.dart';

/// Where a [PriceObservation] came from.
///
/// A computed extension rather than a stored field: `receiptId == null`
/// already IS the distinction, and a second stored flag would be a parallel
/// source of truth that could disagree with it.
extension PriceObservationOriginX on PriceObservation {
  /// True when the user typed this price in themselves.
  ///
  /// Manual rows are the only ones safe to edit or delete in place. A
  /// receipt-derived row is regenerated from its receipt on the next
  /// correction save (`RecordPriceObservationsUseCase` replaces a receipt's
  /// whole set), so "deleting" one would silently come back — the product
  /// page sends those to the receipt editor instead.
  bool get isManual => receiptId == null;
}

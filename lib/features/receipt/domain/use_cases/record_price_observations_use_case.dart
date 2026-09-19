import '../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../models/receipt_item/receipt_item.dart';

/// Derives one [PriceObservation] per receipt line and persists the set.
///
/// [PriceObservation] is the ONLY entity that joins a product to a store
/// (`productId` + `storeId`), so it is what makes "N products" on the Stores
/// list, the store-detail "Products bought here" card, price history and the
/// cross-store comparison work at all. Nothing outside backup import used to
/// write one, which is why every one of those surfaces read empty: the
/// products and the store both existed, but the edge between them never did.
///
/// Its doc comment already said "derived from a [ReceiptItem] at save time" —
/// this is the missing derivation, extracted as a use case (not inlined in
/// either save path) because both the scan-save and the correct-receipt save
/// must produce identical rows. Two copies of this rule would drift.
class RecordPriceObservationsUseCase {
  final IPriceObservationLocalRepository _priceObservationRepository;

  const RecordPriceObservationsUseCase({
    required this._priceObservationRepository,
  });

  /// Replaces [receiptId]'s observations with ones derived from [items].
  ///
  /// REPLACE, not append: a correction can rename a line onto a different
  /// product, change its price, or remove it entirely, and appending would
  /// leave the superseded row behind — inflating the store's product count
  /// and feeding a price history the user already corrected away.
  Future<void> call({
    required String receiptId,
    required String? storeId,
    required List<ReceiptItem> items,
    required DateTime observedAt,
    required String currencyCode,
    required DateTime now,
  }) async {
    await _retireExisting(receiptId);

    final observations = <PriceObservation>[];
    for (final item in items) {
      final productId = item.productId;
      // A line the normalizer could not resolve to a product has no edge to
      // record. Skipping it is correct — a null-product observation would
      // count toward a store's product total while naming no product.
      if (productId == null || productId.isEmpty) continue;

      observations.add(
        PriceObservation(
          id: '${receiptId}_obs_${item.id}',
          productId: productId,
          storeId: storeId,
          receiptId: receiptId,
          observedAt: observedAt,
          comparableUnitPrice: _comparableUnitPrice(
            quantity: item.quantity,
            lineTotal: item.lineTotal,
          ),
          unit: item.unit,
          currencyCode: currencyCode,
          updatedAt: now,
        ),
      );
    }

    if (observations.isEmpty) return;
    await _priceObservationRepository.saveAll(observations);
  }

  /// Hard-removes this receipt's previous observations.
  ///
  /// `deleteLocalOnly` rather than `delete`: a soft delete stamps a tombstone
  /// that PUBLISHES, and these rows are being replaced by fresh ones in the
  /// same operation. Propagating "deleted" for a row the very next write
  /// recreates is churn the other devices would have to reconcile.
  Future<void> _retireExisting(String receiptId) async {
    final existing = await _priceObservationRepository.getAllIncludingDeleted();
    for (final observation in existing) {
      if (observation.receiptId != receiptId) continue;
      await _priceObservationRepository.deleteLocalOnly(observation.id);
    }
  }

  /// The price on a comparable basis — per kg, per litre, or per piece.
  ///
  /// `ReceiptQuantityExtractor.comparableUnitPrice` computes the weighed case
  /// but returns null for pieces, while this field is non-nullable. So the
  /// same division is applied uniformly here: for a piece line `lineTotal /
  /// quantity` IS the per-piece price, which is exactly what a cross-store
  /// comparison of that product needs.
  ///
  /// A non-positive quantity falls back to the line total rather than
  /// dividing — an OCR'd `0` quantity must not produce an infinity that then
  /// renders as a price.
  double _comparableUnitPrice({
    required double quantity,
    required double lineTotal,
  }) {
    if (quantity <= 0) return _roundToCents(lineTotal);
    return _roundToCents(lineTotal / quantity);
  }

  double _roundToCents(double value) => (value * 100).round() / 100;
}

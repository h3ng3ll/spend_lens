part of 'product_detail_bloc.dart';

@freezed
sealed class ProductDetailEvent with _$ProductDetailEvent {
  /// Subscribes to the combined snapshot. Dispatched once from
  /// `ProductDetailPage.initState`.
  const factory ProductDetailEvent.watch() = _Watch;

  /// Records a price the USER typed, as an observation with a null
  /// `receiptId` — see `PriceObservationOriginX.isManual`.
  const factory ProductDetailEvent.addPrice({
    required double unitPrice,
    required DateTime observedAt,
    required String? storeId,
    required String currencyCode,
  }) = _AddPrice;

  /// Edits an existing MANUAL price point. A receipt-derived one is not
  /// editable here — `RecordPriceObservationsUseCase` would regenerate it
  /// from its receipt on the next correction, so the edit would silently
  /// revert; the page sends those to the receipt editor instead.
  const factory ProductDetailEvent.updatePrice({
    required String observationId,
    required double unitPrice,
    required DateTime observedAt,
    required String? storeId,
  }) = _UpdatePrice;

  const factory ProductDetailEvent.deletePrice(String observationId) =
      _DeletePrice;

  /// Renames the product. Its `normalizedName` is deliberately NOT rewritten
  /// — that is the matcher key, and changing it would orphan every alias and
  /// stop future scans resolving to this product. The previous display name
  /// is kept as an alias instead, so the printed spelling still matches.
  const factory ProductDetailEvent.rename(String displayName) = _Rename;

  const factory ProductDetailEvent.setCategory(String categoryId) =
      _SetCategory;

  /// Changes the unit a price is quoted in — piece, kg or litre.
  ///
  /// Carried on the product because it is what a new price point defaults
  /// to; existing observations keep the unit they were recorded with, since
  /// that is what the price they hold actually measured.
  const factory ProductDetailEvent.setUnit(EUnit unit) = _SetUnit;

  /// Moves the product to another store, or to general purpose when null.
  ///
  /// Existing observations keep their OWN `storeId` — they record where a
  /// price was actually seen, which is history and must not be rewritten.
  const factory ProductDetailEvent.setStore(String? storeId) = _SetStore;

  const factory ProductDetailEvent.deleteProduct() = _DeleteProduct;
}

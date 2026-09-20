import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';
import '../../../../product/domain/models/product/e_unit.dart';

part 'price_observation.freezed.dart';
part 'price_observation.g.dart';

/// One price data point for a [Product] at a [Store] and point in time
/// (design_spendlens.md §3) — the raw material for the price-history
/// calculator (spec §54–57, e.g. `18.50 → 22.90 = +23.8%`) and the
/// Stores-detail cross-store comparison lines. Derived from a
/// [ReceiptItem] at save time, OR entered by hand on the product page — a
/// manual row is the one with a null [receiptId].
@freezed
sealed class PriceObservation with _$PriceObservation {
  const factory PriceObservation({
    required String id,
    required String productId,
    String? storeId,
    /// The receipt this price came from, or NULL when the user entered it by
    /// hand on the product page.
    ///
    /// Null is the ONLY marker distinguishing a manual price from a derived
    /// one, and it is load-bearing: `RecordPriceObservationsUseCase` retires
    /// a receipt's observations by matching this field, so a manual row must
    /// never carry a receipt id — a sentinel string would be swept away the
    /// moment a receipt happened to use it.
    String? receiptId,
    required DateTime observedAt,

    /// Unit price normalized to a comparable basis (e.g. `/kg`, `/L`, `/pc`)
    /// — this is what price-history comparison charts and sorts on.
    required double comparableUnitPrice,
    @Default(EUnit.piece) EUnit unit,
    required String currencyCode,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _PriceObservation;

  factory PriceObservation.fromJson(Map<String, dynamic> json) =>
      _$PriceObservationFromJson(json);
}

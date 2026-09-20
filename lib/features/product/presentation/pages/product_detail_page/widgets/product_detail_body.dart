import 'package:flutter/material.dart';

import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../../analytics/domain/price_history/dominant_observation_currency.dart';
import '../../../../../analytics/domain/price_history/price_history_calculator.dart';
import '../../../../domain/models/product_detail_snapshot/product_detail_snapshot.dart';
import '../../../utils/product_price_points.dart';
import 'product_delete_section.dart';
import 'product_identity_card.dart';
import 'product_inflation_card.dart';
import 'product_price_list_card.dart';

/// Populated presentation for `ProductDetailPage`: identity, the inflation
/// chart, the editable price list, the manual cross-store links, and delete.
///
/// Every narrowing here is a pure function over the snapshot computed on
/// build (BLoC rule A3.1 — no derived state), so the page and the store
/// screens can never disagree about what a product has.
class ProductDetailBody extends StatelessWidget {
  final ProductDetailSnapshot snapshot;
  final VoidCallback onAddPrice;
  final ValueChanged<PriceObservation> onEditPrice;
  final ValueChanged<PriceObservation> onOpenReceipt;
  final ValueChanged<PriceObservation> onDeletePrice;
  final VoidCallback onDelete;

  /// Opens the edit sheet for name, store, category and unit.
  final VoidCallback onEdit;
  final VoidCallback onOpenFullHistory;

  const ProductDetailBody({
    super.key,
    required this.snapshot,
    required this.onAddPrice,
    required this.onEditPrice,
    required this.onOpenReceipt,
    required this.onDeletePrice,
    required this.onDelete,
    required this.onEdit,
    required this.onOpenFullHistory,
  });

  @override
  Widget build(BuildContext context) {
    final product = snapshot.product!;
    final pricePoints = pricePointsForProduct(
      snapshot.observations,
      product.id,
      storeId: product.storeId,
    );

    // The chart is fed the ALREADY-SCOPED list, not the global one. Passing
    // the filtered set rather than teaching the calculator about stores
    // keeps one definition of "this product's prices here" — otherwise the
    // list and the curve above it could disagree, and the curve would be
    // the one nobody could check.
    final summary = buildPriceHistory(
      productId: product.id,
      allObservations: pricePoints,
      displayCurrencyCode: dominantObservationCurrency(
        pricePoints,
        product.id,
      ),
    );

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              ProductIdentityCard(
                product: product,
                storeName: storeNameFor(snapshot.stores, product.storeId),
                onEdit: onEdit,
              ),
              // Only once there is something to chart. A product with a
              // single price has no movement to show, and an axis with one
              // bar reads as a rendering fault rather than as "no data yet".
              if (summary.points.length > 1)
                ProductInflationCard(
                  summary: summary,
                  onOpenFullHistory: onOpenFullHistory,
                ),
              ProductPriceListCard(
                pricePoints: pricePoints,
                stores: snapshot.stores,
                onAddPrice: onAddPrice,
                onEditPrice: onEditPrice,
                onOpenReceipt: onOpenReceipt,
                onDeletePrice: onDeletePrice,
              ),
              ProductDeleteSection(
                pricePointCount: pricePoints.length,
                onDelete: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

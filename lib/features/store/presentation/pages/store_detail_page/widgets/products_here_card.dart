import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../../../../core/resources/app_icons.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../../analytics/domain/price_history/store_price_comparator.dart';
import '../../../../../product/domain/models/product/product.dart';
import '../../../../domain/models/store/store.dart';
import 'store_product_row.dart';

/// "Products bought here" (design_spendlens.md's Stores artboard,
/// `hasStoreSel` branch's `productsHere` section).
///
/// Renders the real cross-store comparison lines
/// (design_spendlens.md's Conflicts table: "Both" resolution —
/// `SpendLens Prototype.dc.html` line 885's `p.better` tri-state) once M7/M8
/// scanning has written [PriceObservation]s for this store's products. When
/// there are none yet — true for every M5/M6 install with zero receipts
/// scanned — this renders the SAME honest empty state M5 shipped, never a
/// fabricated row.
class ProductsHereCard extends StatelessWidget {
  final String storeId;
  final List<Product> products;
  final List<PriceObservation> priceObservations;
  final List<Store> stores;
  final String displayCurrencyCode;

  const ProductsHereCard({
    super.key,
    required this.storeId,
    required this.products,
    required this.priceObservations,
    required this.stores,
    required this.displayCurrencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    final productIdsHere = priceObservations
        .where(
          (observation) =>
              observation.storeId == storeId && observation.deletedAt == null,
        )
        .map((observation) => observation.productId)
        .toSet();

    if (productIdsHere.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.0,
        children: [
          SectionLabel(text: lo.productsHere),
          AppEmptyState(
            icon: AppIcons.emptyReceipt,
            title: lo.storeNoProductsYet,
            body: lo.storeNoProductsYetBody,
          ),
        ],
      );
    }

    final rows = <Widget>[];
    for (final productId in productIdsHere) {
      final product = _findProduct(productId);
      if (product == null) continue;

      final comparison = compareStorePriceForProduct(
        productId: productId,
        atStoreId: storeId,
        allObservations: priceObservations,
        stores: stores,
      );

      rows.add(
        StoreProductRow(product: product, comparison: comparison),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.0,
      children: [
        SectionLabel(text: lo.productsHere),
        ...rows,
      ],
    );
  }

  Product? _findProduct(String productId) {
    for (final product in products) {
      if (product.id == productId) return product;
    }
    return null;
  }
}

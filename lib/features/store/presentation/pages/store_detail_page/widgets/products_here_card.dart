import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/create_new_row.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../../../../core/resources/app_icons.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../../analytics/domain/price_history/store_price_comparator.dart';
import '../../../../../product/domain/linking/linked_product_group.dart';
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

  /// Opens a product's page.
  final ValueChanged<String> onOpenProduct;

  /// Records a product at this store without the camera.
  final VoidCallback onAddProduct;

  const ProductsHereCard({
    super.key,
    required this.storeId,
    required this.products,
    required this.priceObservations,
    required this.stores,
    required this.onOpenProduct,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    // OWNERSHIP, not observation location. Listing by where prices were
    // SEEN put one store-less product under every shop it was ever bought
    // at; `Product.storeId` is the single source of truth for membership,
    // and the per-store split migration makes it true of legacy data too.
    //
    // An observation recorded at a different store still counts toward the
    // cross-store comparison below — where a price was seen and which store
    // owns the product are genuinely different facts, and only the second
    // decides what this list contains.
    final productsHere = products
        .where(
          (product) =>
              product.storeId == storeId && product.deletedAt == null,
        )
        .toList();

    if (productsHere.isEmpty) {
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
          // Offered in the EMPTY branch too: a store with nothing recorded
          // is exactly when the user most needs a way to record something,
          // and hiding the only create path behind a non-empty list would
          // strand the store permanently.
          CreateNewRow(
            title: lo.addProduct,
            subtitle: lo.addProductSub,
            onTap: onAddProduct,
          ),
        ],
      );
    }

    final rows = <Widget>[];
    for (final product in productsHere) {
      // Grouped over the product's link set rather than a bare id: products
      // are per-store, so the same goods at two shops are two rows, and only
      // the links make them comparable. The split migration writes those
      // links automatically for products it separates.
      final comparison = compareStorePriceForProduct(
        productId: product.id,
        atStoreId: storeId,
        allObservations: priceObservations,
        stores: stores,
        comparableProductIds: resolveLinkedGroup(product.id, products),
      );

      rows.add(
        StoreProductRow(
          product: product,
          comparison: comparison,
          onTap: () => onOpenProduct(product.id),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.0,
      children: [
        SectionLabel(text: lo.productsHere),
        ...rows,
        CreateNewRow(
          title: lo.addProduct,
          subtitle: lo.addProductSub,
          onTap: onAddProduct,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../domain/models/store_detail_snapshot/store_detail_snapshot.dart';
import '../../../utils/store_aggregates.dart';
import 'products_here_card.dart';
import 'store_delete_section.dart';
import 'store_detail_header.dart';
import 'store_stats_row.dart';

/// Populated presentation for `StoreDetailPage`
/// (design_spendlens.md's Stores artboard, `hasStoreSel` branch): header,
/// 3-column stats row, "Products bought here" (real cross-store comparison
/// lines once M7/M8 scanning has written observations; honest empty state
/// until then), and the delete-store section — always shown now, since a
/// referenced store can be deleted along with its records.
class StoreDetailBody extends StatelessWidget {
  final StoreDetailSnapshot snapshot;
  final VoidCallback onClose;

  /// Opens the edit-store sheet for this store's name and logo.
  final VoidCallback onEdit;

  /// Opens one product's page.
  final ValueChanged<String> onOpenProduct;

  /// Records a product at this store without the camera.
  final VoidCallback onAddProduct;

  const StoreDetailBody({
    super.key,
    required this.snapshot,
    required this.onClose,
    required this.onEdit,
    required this.onOpenProduct,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    final store = snapshot.store!;
    final storeExpenses = expensesForStore(snapshot.expenses, store.id);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          StoreDetailHeader(
            storeName: store.name,
            onClose: onClose,
            onEdit: onEdit,
          ),
          HorizontalPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                StoreStatsRow(
                  storeExpenses: storeExpenses,
                  priceObservations: snapshot.priceObservations,
                  storeId: store.id,
                ),
                ProductsHereCard(
                  storeId: store.id,
                  products: snapshot.products,
                  priceObservations: snapshot.priceObservations,
                  stores: snapshot.stores,
                  onOpenProduct: onOpenProduct,
                  onAddProduct: onAddProduct,
                ),
                StoreDeleteSection(storeId: store.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

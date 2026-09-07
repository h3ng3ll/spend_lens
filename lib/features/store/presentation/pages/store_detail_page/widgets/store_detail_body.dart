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
/// 3-column stats row, "Products bought here" (honest empty in M5 — zero
/// products/PriceObservations exist until receipt scanning ships in M7/M8),
/// and the delete-store section when no expense references this store.
class StoreDetailBody extends StatelessWidget {
  final StoreDetailSnapshot snapshot;
  final VoidCallback onClose;

  const StoreDetailBody({
    super.key,
    required this.snapshot,
    required this.onClose,
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
          StoreDetailHeader(storeName: store.name, onClose: onClose),
          HorizontalPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                StoreStatsRow(storeExpenses: storeExpenses),
                const ProductsHereCard(),
                StoreDeleteSection(storeId: store.id, expenses: storeExpenses),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

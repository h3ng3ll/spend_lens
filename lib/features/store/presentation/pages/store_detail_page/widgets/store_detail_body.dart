import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
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
/// until then), and the delete-store section when no expense references
/// this store.
class StoreDetailBody extends StatelessWidget {
  final StoreDetailSnapshot snapshot;
  final VoidCallback onClose;

  /// Opens the edit-store sheet for this store's name and logo.
  final VoidCallback onEdit;

  const StoreDetailBody({
    super.key,
    required this.snapshot,
    required this.onClose,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final store = snapshot.store!;
    final storeExpenses = expensesForStore(snapshot.expenses, store.id);
    final displayCurrencyCode = context
        .watch<SettingsBloc>()
        .state
        .settings
        .currencyCode;

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
                StoreStatsRow(storeExpenses: storeExpenses),
                ProductsHereCard(
                  storeId: store.id,
                  products: snapshot.products,
                  priceObservations: snapshot.priceObservations,
                  stores: snapshot.stores,
                  displayCurrencyCode: displayCurrencyCode,
                ),
                StoreDeleteSection(storeId: store.id, expenses: storeExpenses),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

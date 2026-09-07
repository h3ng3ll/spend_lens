import 'package:flutter/material.dart';

import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../domain/models/store/store.dart';
import 'store_list_row.dart';

/// The card grouping every store row (design_spendlens.md's Stores artboard
/// — `noStoreSel` branch's store list card). Layout only (A6, Container
/// Rule) — receives the data and lets [StoreListRow] render each row.
class StoreListCard extends StatelessWidget {
  final List<Store> stores;
  final List<Expense> expenses;

  const StoreListCard({
    super.key,
    required this.stores,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < stores.length; i++)
            StoreListRow(
              store: stores[i],
              expenses: expenses,
              showBottomDivider: i != stores.length - 1,
            ),
        ],
      ),
    );
  }
}

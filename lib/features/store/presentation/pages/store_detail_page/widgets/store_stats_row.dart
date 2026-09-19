import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../utils/store_aggregates.dart';
import 'store_stat_card.dart';

/// The 3-column Visits / Spent / Products stat row
/// (design_spendlens.md's Stores artboard, `hasStoreSel` branch). "Products"
/// is always 0 in M5 — honest, since products/PriceObservations require
/// scanned receipts (M7/M8), never fabricated.
class StoreStatsRow extends StatelessWidget {
  final List<Expense> storeExpenses;

  const StoreStatsRow({super.key, required this.storeExpenses});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    final visits = visitCount(storeExpenses);
    final allTime = totalSpentAllTime(storeExpenses);
    final spentText = allTime == null
        ? '—'
        : '${formatAmount(allTime.amount)} ${allTime.currencyCode}';

    return Column(
      children: [
        SizedBox(
          height: 80.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10.0,
            children: [
              Expanded(
                child: StoreStatCard(
                  label: lo.visits,
                  value: '$visits',
                ),
              ),
              Expanded(
                child: StoreStatCard(label: lo.products, value: '0'),
              ),
            ],
          ),
        ),
        Gap(5.0),
        StoreStatCard(
          label: lo.spent,
          value: spentText,
        ),
      ],
    );
  }
}

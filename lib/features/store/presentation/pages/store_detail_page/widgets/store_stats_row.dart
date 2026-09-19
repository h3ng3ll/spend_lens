import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../analytics/domain/models/price_observation/price_observation.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../utils/store_aggregates.dart';
import 'store_stat_card.dart';

/// The 3-column Visits / Spent / Products stat row
/// (design_spendlens.md's Stores artboard, `hasStoreSel` branch).
///
/// "Products" counts the distinct products observed at this store. It used to
/// be a hardcoded `0` from when nothing wrote a [PriceObservation]; the scan
/// and correction save paths now record them, so the real count is both
/// available and non-zero. It is derived through the same
/// `productCountForStore` helper the Stores LIST uses, so the two screens
/// cannot disagree.
class StoreStatsRow extends StatelessWidget {
  final List<Expense> storeExpenses;
  final List<PriceObservation> priceObservations;
  final String storeId;

  const StoreStatsRow({
    super.key,
    required this.storeExpenses,
    required this.priceObservations,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    final visits = visitCount(storeExpenses);
    final products = productCountForStore(priceObservations, storeId);
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
                child: StoreStatCard(label: lo.products, value: '$products'),
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

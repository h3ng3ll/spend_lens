import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../../core/widgets/record_list_row.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../domain/models/store/e_store_type.dart';
import '../../../../domain/models/store/store.dart';
import '../../../utils/store_aggregates.dart';

/// One store row (design_spendlens.md's Stores artboard — `st` loop item):
/// initial tile, name + "{visits} visits · {products} products" meta,
/// trailing spent-this-month total + "this month" caption, chevron.
///
/// [RecordListRow] already guards against the fixed-dp-row-height chronic
/// bug (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`)
/// — this widget only supplies content, never a height.
class StoreListRow extends StatelessWidget {
  final Store store;
  final List<Expense> expenses;
  final bool showBottomDivider;

  const StoreListRow({
    super.key,
    required this.store,
    required this.expenses,
    required this.showBottomDivider,
  });

  void _onTap(BuildContext context) {
    StoreDetailPageRoute(storeId: store.id).push(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    final storeExpenses = expensesForStore(expenses, store.id);
    final visits = visitCount(storeExpenses);
    final thisMonth = totalSpentThisMonth(storeExpenses, DateTime.now());

    final meta = visits == 0
        ? lo.storeEmpty(_storeTypeLabel(lo, store))
        : lo.storeMeta(visits, 0);

    final amountText = thisMonth == null
        ? '—'
        : '${formatAmount(thisMonth.amount)} ${thisMonth.currencyCode}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RecordListRow(
          initial: store.name.isEmpty ? '?' : store.name[0].toUpperCase(),
          tileBackground: scheme.accentTint,
          tileForeground: scheme.accent,
          title: store.name,
          meta: meta,
          amountText: amountText,
          onTap: () => _onTap(context),
          showBottomDivider: showBottomDivider,
        ),
      ],
    );
  }

  String _storeTypeLabel(AppLocalizations lo, Store store) {
    switch (store.type) {
      case EStoreType.supermarket:
        return lo.storeTypeSupermarket;
      case EStoreType.market:
        return lo.storeTypeMarket;
      case EStoreType.pharmacy:
        return lo.storeTypePharmacy;
      case EStoreType.cafe:
        return lo.storeTypeCafe;
      case EStoreType.store:
        return lo.storeTypeStore;
      case EStoreType.other:
        return lo.storeTypeOther;
    }
  }
}

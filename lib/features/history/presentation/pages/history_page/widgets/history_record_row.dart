import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../../core/widgets/record_list_row.dart';
import '../../../../../category/domain/models/category/category.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../../store/domain/models/store/store.dart';
import 'history_row_view_data.dart';

/// One row of [HistoryRecordList] — resolves its own [HistoryRowViewData]
/// and navigates to [RecordDetailPageRoute] on tap. Its own file (A2 — no
/// `_buildWidget()` private methods in a container widget).
class HistoryRecordRow extends StatelessWidget {
  final Expense expense;
  final List<Category> categories;
  final List<Store> stores;
  final bool showBottomDivider;

  const HistoryRecordRow({
    super.key,
    required this.expense,
    required this.categories,
    required this.stores,
    required this.showBottomDivider,
  });

  void _onTap(BuildContext context) {
    RecordDetailPageRoute(recordId: expense.id).push<void>(context);
  }

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final viewData = HistoryRowViewData.resolve(
      expense: expense,
      categories: categories,
      stores: stores,
      lo: lo,
    );

    return RecordListRow(
      initial: viewData.initial,
      tileBackground: viewData.tileBackground,
      tileForeground: viewData.tileForeground,
      title: viewData.name,
      meta: viewData.meta,
      amountText: viewData.amountText,
      showBottomDivider: showBottomDivider,
      onTap: () => _onTap(context),
    );
  }
}

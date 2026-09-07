import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../category/domain/models/category/category.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../../home/presentation/utils/category_name_resolver.dart';
import '../../../../../store/domain/models/store/store.dart';

/// Everything [RecordDetailCard] needs to render ONE [Expense], resolved
/// once from the raw snapshot. A plain view-data holder, not a bloc state
/// field — derived fresh from `RecordDetailSnapshot` at build time (BLoC
/// rule A3.1).
///
/// M5 scope boundary: covers the cash-expense branch only (every record in
/// History at this milestone is `source: cash`) — see `RecordDetailPage`'s
/// doc comment.
class RecordDetailViewData {
  final String initial;
  final Color tileBackground;
  final Color tileForeground;
  final String name;
  final String dateText;
  final String amountText;
  final String currencyCode;
  final String categoryLabel;
  final Color categoryDotColor;
  final String? note;

  const RecordDetailViewData({
    required this.initial,
    required this.tileBackground,
    required this.tileForeground,
    required this.name,
    required this.dateText,
    required this.amountText,
    required this.currencyCode,
    required this.categoryLabel,
    required this.categoryDotColor,
    required this.note,
  });

  factory RecordDetailViewData.resolve({
    required Expense expense,
    required List<Category> categories,
    required List<Store> stores,
    required AppLocalizations lo,
  }) {
    final categoryById = {for (final c in categories) c.id: c};
    final category = categoryById[expense.categoryId];

    final categoryLabel = category != null ? resolveCategoryName(lo, category) : lo.catOther;
    final color = category != null
        ? resolveCategoryColor(category)
        : resolveCategoryColorForOther();

    final storeId = expense.storeId;
    final store = storeId == null
        ? null
        : stores.where((candidate) => candidate.id == storeId).cast<Store?>().firstWhere(
              (_) => true,
              orElse: () => null,
            );

    final displayName = store?.name ?? categoryLabel;
    final numberFormat = NumberFormat.decimalPattern();

    return RecordDetailViewData(
      initial: displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
      tileBackground: color.withValues(alpha: 0.13),
      tileForeground: color,
      name: displayName,
      dateText: DateFormat.yMMMd().add_jm().format(expense.occurredAt),
      amountText: numberFormat.format(expense.amount),
      currencyCode: expense.currencyCode,
      categoryLabel: categoryLabel,
      categoryDotColor: color,
      note: expense.note,
    );
  }
}

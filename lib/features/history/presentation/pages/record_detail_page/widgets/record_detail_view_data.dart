import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/models/e_sync_status.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/services/sync_status_presenter/sync_status_presenter.dart';
import '../../../../../category/domain/models/category/category.dart';
import '../../../../../expense/domain/models/expense/e_expense_source.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../../home/presentation/utils/category_name_resolver.dart';
import '../../../../../receipt/domain/models/receipt/receipt.dart';
import '../../../../../store/domain/models/store/store.dart';

/// Everything [RecordDetailCard] needs to render ONE [Expense], resolved
/// once from the raw snapshot. A plain view-data holder, not a bloc state
/// field — derived fresh from `RecordDetailSnapshot` at build time (BLoC
/// rule A3.1).
///
/// Covers BOTH branches of the design's Record detail artboard. [isReceipt]
/// selects between them, and it is derived from `Expense.source` — never
/// passed in by the caller.
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

  /// True when this record came from a scanned/entered receipt
  /// (`EExpenseSource.receipt`) — the branch that shows the Items card, the
  /// Receipt photo card and the Edit action.
  final bool isReceipt;

  /// `dType` — the header title AND the type badge label: "Receipt" or
  /// "Cash".
  final String typeLabel;

  /// `dDeleteLabel` — "Delete receipt" or "Delete expense".
  final String deleteLabel;

  /// The sync badge's label, or null when there is no receipt to report on.
  ///
  /// Null for a cash expense DELIBERATELY. A receipt and its mirrored
  /// expense are two separate rows stamped independently, so their
  /// `syncStatus` values drift — showing the expense's status on a screen
  /// the user reads as "the receipt" would misreport it.
  final String? syncLabel;

  /// Dot colour paired with [syncLabel]; null whenever that is null.
  final Color? syncDotColor;

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
    required this.isReceipt,
    required this.typeLabel,
    required this.deleteLabel,
    required this.syncLabel,
    required this.syncDotColor,
  });

  factory RecordDetailViewData.resolve({
    required Expense expense,
    required List<Category> categories,
    required List<Store> stores,
    required Receipt? receipt,
    required AppLocalizations lo,
    required AppColorScheme scheme,
    SyncStatusPresenter syncStatusPresenter = const SyncStatusPresenter(),
  }) {
    final categoryById = {for (final c in categories) c.id: c};
    final category = categoryById[expense.categoryId];

    final categoryLabel = category != null
        ? resolveCategoryName(lo, category)
        : lo.catOther;
    final color = category != null
        ? resolveCategoryColor(category)
        : resolveCategoryColorForOther();

    final isReceipt = expense.source == EExpenseSource.receipt;

    // The store comes from the RECEIPT first, then the expense. A
    // receipt-sourced expense is written by `CreateExpenseFromReceiptUseCase`
    // WITHOUT a storeId (`ReviewBloc` does not pass one), so reading only
    // `Expense.storeId` would show the category name as the record's title
    // on every scanned receipt — even after Edit receipt set the store.
    final storeId = receipt?.storeId ?? expense.storeId;
    final store = storeId == null
        ? null
        : stores.where((candidate) => candidate.id == storeId).firstOrNull;

    final displayName = store?.name ?? categoryLabel;
    final numberFormat = NumberFormat.decimalPattern();

    // `dDate` is "Sep 6, 2026 · Receipt" — the date, then the record type.
    // No clock time: the design's detail card carries the day, and a
    // receipt's purchase time is not meaningful to the day's total.
    final occurredAt = receipt?.purchasedAt ?? expense.occurredAt;
    final typeLabel = isReceipt ? lo.receipt : lo.cashType;

    // Reported from the RECEIPT's own row — see [syncLabel].
    final ESyncStatus? syncStatus = isReceipt ? receipt?.syncStatus : null;

    return RecordDetailViewData(
      initial: displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
      tileBackground: color.withValues(alpha: 0.13),
      tileForeground: color,
      name: displayName,
      dateText: '${DateFormat.yMMMd().format(occurredAt)} · $typeLabel',
      amountText: numberFormat.format(expense.amount),
      currencyCode: expense.currencyCode,
      categoryLabel: categoryLabel,
      categoryDotColor: color,
      note: expense.note,
      isReceipt: isReceipt,
      typeLabel: typeLabel,
      deleteLabel: isReceipt ? lo.deleteReceipt : lo.deleteExpense,
      syncLabel: syncStatus == null
          ? null
          : syncStatusPresenter.label(syncStatus, lo),
      syncDotColor: syncStatus == null
          ? null
          : syncStatusPresenter.color(syncStatus, scheme),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../category/domain/models/category/category.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../../home/presentation/utils/category_name_resolver.dart';
import '../../../../../home/presentation/utils/home_calculations.dart';
import '../../../../../store/domain/models/store/store.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';

/// Everything [RecordListRow] (and the Record Detail card) needs to render
/// ONE [Expense], resolved once from the raw snapshot — the initial letter,
/// tile background/foreground, display name, meta line and formatted amount.
///
/// A plain view-data holder, not a bloc state field: it is derived fresh
/// from `HistorySnapshot` at build time (BLoC rule A3.1). Mirrors Home's
/// `HomeRecentEntry` shape/tile-color convention
/// (`tileBackground: color.withValues(alpha: 0.13)`, `tileForeground: color`)
/// and reuses its `recentExpenseMeta` for the meta line, so a record reads
/// identically whether it is seen from Home's Recent card or from History.
class HistoryRowViewData {
  final String initial;
  final Color tileBackground;
  final Color tileForeground;
  final String name;
  final String meta;
  final String amountText;

  const HistoryRowViewData({
    required this.initial,
    required this.tileBackground,
    required this.tileForeground,
    required this.name,
    required this.meta,
    required this.amountText,
  });

  /// Resolves [expense] against [categories]/[stores]. Falls back to the
  /// shared "Other" category hue when a lookup misses (e.g. a category
  /// deleted out from under an existing expense) rather than throwing.
  factory HistoryRowViewData.resolve({
    required Expense expense,
    required List<Category> categories,
    required List<Store> stores,
    required AppLocalizations lo,
  }) {
    final categoryById = {for (final c in categories) c.id: c};
    final category = categoryById[expense.categoryId];

    final name = category != null
        ? resolveCategoryName(lo, category)
        : lo.catOther;
    final color = category != null
        ? resolveCategoryColor(category)
        : resolveCategoryColorForOther();

    final numberFormat = NumberFormat.decimalPattern();

    return HistoryRowViewData(
      initial: name.isNotEmpty ? name[0].toUpperCase() : '?',
      tileBackground: color.withValues(alpha: 0.13),
      tileForeground: color,
      name: name,
      meta: recentExpenseMeta(lo, expense, stores),
      amountText:
          '${numberFormat.format(expense.amount)} ${expense.currencyCode}',
    );
  }
}

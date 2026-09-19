import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../category/domain/models/category/category.dart';
import '../../../../expense/domain/models/expense/expense.dart';
import '../../../../home/presentation/utils/home_calculations.dart';
import '../../../../store/domain/models/store/store.dart';

/// One purchase row of the selected-category drill-down card — resolved
/// once here (store/category lookups + formatting), never recomputed inside
/// the widget layer, and never stored as bloc state (BLoC rule A3.1).
class AnalyticsSelectedCategoryEntry {
  final String initial;
  final String title;
  final String meta;
  final String amountText;

  const AnalyticsSelectedCategoryEntry({
    required this.initial,
    required this.title,
    required this.meta,
    required this.amountText,
  });
}

/// Builds the drill-down rows for [categoryId] within [periodExpenses],
/// highest amount first (the design lists the biggest purchases at the top).
///
/// Deliberately delegates every per-row string to Home's
/// [buildRecentEntries]: the design's drill-down row and Home's "Recent" row
/// are the same row — same initial tile, same "category · day · time" meta,
/// same trailing amount — so duplicating that formatting here would be a
/// second place for it to drift.
List<AnalyticsSelectedCategoryEntry> buildSelectedCategoryEntries({
  required AppLocalizations lo,
  required List<Expense> periodExpenses,
  required List<Category> categories,
  required List<Store> stores,
  required String currencyCode,
  required String categoryId,
}) {
  final matching =
      periodExpenses.where((e) => e.categoryId == categoryId).toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));

  return buildRecentEntries(lo, matching, categories, stores, currencyCode)
      .map(
        (entry) => AnalyticsSelectedCategoryEntry(
          initial: entry.initial,
          title: entry.title,
          meta: entry.meta,
          amountText: entry.amountText,
        ),
      )
      .toList();
}

/// The total of [periodExpenses] that belong to [categoryId] — the amount
/// printed in the card's heading beside the category name.
double selectedCategoryTotal({
  required List<Expense> periodExpenses,
  required String categoryId,
}) {
  return periodExpenses
      .where((e) => e.categoryId == categoryId)
      .fold(0.0, (sum, e) => sum + e.amount);
}

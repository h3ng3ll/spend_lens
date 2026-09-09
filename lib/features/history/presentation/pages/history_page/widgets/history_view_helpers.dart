import '../../../../../category/domain/models/category/category.dart';
import '../../../../../expense/domain/models/expense/e_expense_source.dart';
import '../../../../../expense/domain/models/expense/expense.dart';
import '../../../../../home/presentation/utils/category_name_resolver.dart';
import '../../../../../store/domain/models/store/store.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import 'e_history_filter.dart';

/// Search + record-type filtering, computed as a PURE function over the raw,
/// unfiltered expense list — never a `filteredX` bloc-state field (BLoC rule
/// A3.1). Called fresh on every `HistoryBody` build.
///
/// CHRONIC BUG GUARD
/// (`sig:filter-miss-empty-state-absent-only-the-unfiltered-empty-state-exists`):
/// the caller MUST branch on the RESULT of this function — not only on the
/// raw `expenses` list — or a filter/search combination matching zero items
/// falls through to the list-rendering branch and renders a blank body.
///
/// Matches by category display name, store name, and note text
/// (case-insensitive substring); the record-type filter matches
/// `Expense.source`.
List<Expense> filterHistoryExpenses({
  required List<Expense> expenses,
  required List<Category> categories,
  required List<Store> stores,
  required AppLocalizations lo,
  required String query,
  required EHistoryFilter filter,
}) {
  final normalizedQuery = query.trim().toLowerCase();

  return expenses.where((expense) {
    if (!_matchesFilter(expense, filter)) return false;
    if (normalizedQuery.isEmpty) return true;
    return _matchesQuery(
      expense: expense,
      categories: categories,
      stores: stores,
      lo: lo,
      normalizedQuery: normalizedQuery,
    );
  }).toList();
}

bool _matchesFilter(Expense expense, EHistoryFilter filter) {
  switch (filter) {
    case EHistoryFilter.all:
      return true;
    case EHistoryFilter.receipts:
      return expense.source == EExpenseSource.receipt;
    case EHistoryFilter.cash:
      return expense.source == EExpenseSource.cash;
  }
}

bool _matchesQuery({
  required Expense expense,
  required List<Category> categories,
  required List<Store> stores,
  required AppLocalizations lo,
  required String normalizedQuery,
}) {
  final category = categories
      .where((candidate) => candidate.id == expense.categoryId)
      .cast<Category?>()
      .firstWhere((_) => true, orElse: () => null);
  if (category != null &&
      resolveCategoryName(lo, category).toLowerCase().contains(
        normalizedQuery,
      )) {
    return true;
  }

  final storeId = expense.storeId;
  if (storeId != null) {
    final store = stores
        .where((candidate) => candidate.id == storeId)
        .cast<Store?>()
        .firstWhere((_) => true, orElse: () => null);
    if (store != null && store.name.toLowerCase().contains(normalizedQuery)) {
      return true;
    }
  }

  final note = expense.note;
  if (note != null && note.toLowerCase().contains(normalizedQuery)) {
    return true;
  }

  return false;
}

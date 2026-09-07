/// The analytics engine's calculator (design_spendlens.md §6/§10/§11) — pure
/// functions only, so tests need no mocks. Computes monthly totals,
/// previous-month comparison, % change, average, per-category share and
/// count, and the cash-vs-receipt split, **always from Expenses (+
/// ReceiptItems for price-history, in the sibling calculator)**, never
/// stored as a derived source of truth (spec §49).
///
/// Every sum here goes through [totalInCurrency] — currencies are never
/// silently combined (spec §52, §11).
library;

import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/e_expense_source.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../models/monthly_summary/category_share.dart';
import '../models/monthly_summary/monthly_summary.dart';
import 'currency_guard.dart';

/// Expenses whose `occurredAt` falls in the given (year, 0-based month).
List<Expense> expensesInMonth(
  List<Expense> expenses,
  int year,
  int month,
) {
  return expenses
      .where(
        (expense) =>
            expense.occurredAt.year == year &&
            expense.occurredAt.month - 1 == month,
      )
      .toList();
}

/// Builds the full [MonthlySummary] for (year, month) against
/// [displayCurrencyCode]. [categories] resolves each expense's
/// `categoryId` to a per-category share/count row.
MonthlySummary buildMonthlySummary({
  required List<Expense> allExpenses,
  required List<Category> categories,
  required int year,
  required int month,
  required String displayCurrencyCode,
}) {
  final monthExpenses = expensesInMonth(allExpenses, year, month)
      .where((expense) => expense.currencyCode == displayCurrencyCode)
      .toList();

  final total = totalInCurrency(monthExpenses, displayCurrencyCode);
  final purchaseCount = monthExpenses.length;
  final average = purchaseCount == 0 ? 0.0 : total / purchaseCount;

  final cashCount = monthExpenses
      .where((expense) => expense.source == EExpenseSource.cash)
      .length;
  final cashShare = purchaseCount == 0 ? 0.0 : cashCount / purchaseCount;

  final categoryShares = _categoryShares(monthExpenses, categories, total);

  final previousMonth = month == 0 ? 11 : month - 1;
  final previousYear = month == 0 ? year - 1 : year;
  final previousMonthExpenses =
      expensesInMonth(allExpenses, previousYear, previousMonth)
          .where((expense) => expense.currencyCode == displayCurrencyCode)
          .toList();
  final previousMonthTotal = previousMonthExpenses.isEmpty
      ? null
      : totalInCurrency(previousMonthExpenses, displayCurrencyCode);

  return MonthlySummary(
    year: year,
    month: month,
    currencyCode: displayCurrencyCode,
    total: total,
    purchaseCount: purchaseCount,
    averagePurchase: average,
    cashShare: cashShare,
    categoryShares: categoryShares,
    previousMonthTotal: previousMonthTotal,
  );
}

List<CategoryShare> _categoryShares(
  List<Expense> monthExpenses,
  List<Category> categories,
  double total,
) {
  final amountByCategory = <String, double>{};
  final countByCategory = <String, int>{};

  for (final expense in monthExpenses) {
    amountByCategory[expense.categoryId] =
        (amountByCategory[expense.categoryId] ?? 0.0) + expense.amount;
    countByCategory[expense.categoryId] =
        (countByCategory[expense.categoryId] ?? 0) + 1;
  }

  final shares = <CategoryShare>[];
  for (final category in categories) {
    final amount = amountByCategory[category.id];
    if (amount == null || amount <= 0) {
      continue;
    }
    shares.add(
      CategoryShare(
        categoryId: category.id,
        amount: amount,
        count: countByCategory[category.id] ?? 0,
        sharePercent: total > 0 ? (amount / total) * 100 : 0.0,
      ),
    );
  }

  shares.sort((a, b) => b.amount.compareTo(a.amount));
  return shares;
}

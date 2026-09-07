/// Refuses to silently combine currencies (design_spendlens.md §6/§11, spec
/// §52): receipts/expenses keep their own printed `currencyCode`; totals are
/// computed **only** over the single display currency the caller asks for.
/// There is no conversion anywhere in this app — an amount in a currency
/// other than the requested one is excluded from the sum, never coerced or
/// summed as if it were the same unit.
library;

import '../../../expense/domain/models/expense/expense.dart';

/// Sum of `amount` across [expenses] whose `currencyCode` equals
/// [displayCurrencyCode] — every other currency is silently EXCLUDED from
/// the sum (never converted, never added in as-is). Returns 0 when nothing
/// matches.
double totalInCurrency(
  List<Expense> expenses,
  String displayCurrencyCode,
) {
  return expenses
      .where((expense) => expense.currencyCode == displayCurrencyCode)
      .fold(0.0, (sum, expense) => sum + expense.amount);
}

/// True when [expenses] contains more than one distinct `currencyCode` —
/// callers can use this to decide whether to warn the user that some
/// expenses are excluded from a single-currency total, without ever
/// attempting to combine them.
bool hasMixedCurrencies(List<Expense> expenses) {
  final codes = expenses.map((expense) => expense.currencyCode).toSet();
  return codes.length > 1;
}

/// The set of distinct currency codes present in [expenses].
Set<String> distinctCurrencies(List<Expense> expenses) {
  return expenses.map((expense) => expense.currencyCode).toSet();
}

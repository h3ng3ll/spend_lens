/// Summing expenses for display.
///
/// The user's settings `currencyCode` is a DISPLAY LABEL only: totals sum
/// every expense given and are then labelled with that code. Amounts are
/// never converted or re-denominated, and an expense's own stored
/// `currencyCode` never removes it from a total.
///
/// This is the single sum used by both Home and Analytics. They previously
/// summed differently — Home over all expenses, Analytics filtered by
/// currency — so the same data produced two contradictory answers on two
/// screens (833 vs 0). One shared function is what keeps them agreeing.
library;

import '../../../expense/domain/models/expense/expense.dart';

/// Sum of `amount` across [expenses], regardless of each one's stored
/// `currencyCode`. Returns 0.0 for an empty list.
double sumAmounts(Iterable<Expense> expenses) =>
    expenses.fold(0.0, (total, expense) => total + expense.amount);

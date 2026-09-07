part of 'cash_expense_bloc.dart';

/// The UI reads these getters, never the enum directly. This is a pure form
/// bloc with no async load phase (there is nothing to fetch — the form
/// starts empty), so `isReady` covers the one non-terminal status
/// (`editing`) rather than a separate `isLoading`.
extension CashExpenseStateX on CashExpenseState {
  bool get isReady => status == ECashExpenseStatus.editing;

  bool get isSaved => status == ECashExpenseStatus.saved;

  bool get isFailed => status == ECashExpenseStatus.failed;
}

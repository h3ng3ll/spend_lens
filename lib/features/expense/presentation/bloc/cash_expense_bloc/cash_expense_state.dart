part of 'cash_expense_bloc.dart';

enum ECashExpenseStatus { editing, saved, failed }

@freezed
sealed class CashExpenseState with _$CashExpenseState {
  const factory CashExpenseState({
    @Default(ECashExpenseStatus.editing) ECashExpenseStatus status,
    String? storeId,
    String? storeName,
  }) = _CashExpenseState;
}

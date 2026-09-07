import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';
import 'e_expense_source.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

/// A single expense entry (design_spendlens.md §3) — the record Analytics
/// and History are computed FROM (spec §49: Expenses + ReceiptItems are
/// always computed from, never stored as the source of truth for anything
/// else). Created either from a saved [Receipt] (`source: receipt`) or the
/// Cash-expense sheet (`source: cash`).
@freezed
sealed class Expense with _$Expense {
  const factory Expense({
    required String id,
    required double amount,
    required String currencyCode,
    required String categoryId,
    String? storeId,
    String? note,
    required DateTime occurredAt,
    @Default(EExpenseSource.cash) EExpenseSource source,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default(ESyncStatus.synced) ESyncStatus syncStatus,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}

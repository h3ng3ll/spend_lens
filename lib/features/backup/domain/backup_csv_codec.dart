import 'package:csv/csv.dart';

import '../../category/domain/models/category/category.dart';
import '../../expense/domain/models/expense/expense.dart';
import '../../store/domain/models/store/store.dart';

/// The result of a CSV export — the string content plus the row count the
/// `tCsv` ARB string (`"Spreadsheet ready · {count} rows"`) reports. `count`
/// is the DATA row count, never including the header row.
class BackupCsvResult {
  final String content;
  final int rowCount;

  const BackupCsvResult({required this.content, required this.rowCount});
}

/// Expense → CSV export (design_spendlens.md §6/§9/§11 — "CSV export" +
/// "CSV escaping and row count" tests).
///
/// Uses the `csv` package's [ListToCsvConverter] for RFC-4180-correct
/// escaping (quoting fields containing commas/quotes/newlines) rather than
/// hand-joining strings — a hand-rolled `.join(',')` is exactly how CSV
/// export bugs happen the moment a store name or note contains a comma.
abstract class BackupCsvCodec {
  static const List<String> _header = [
    'date',
    'amount',
    'currency',
    'category',
    'store',
    'note',
    'source',
  ];

  static BackupCsvResult encode({
    required List<Expense> expenses,
    required List<Category> categories,
    required List<Store> stores,
  }) {
    final categoryById = {for (final c in categories) c.id: c};
    final storeById = {for (final s in stores) s.id: s};

    final rows = <List<dynamic>>[_header];

    for (final expense in expenses) {
      rows.add([
        expense.occurredAt.toIso8601String(),
        expense.amount,
        expense.currencyCode,
        categoryById[expense.categoryId]?.name ?? expense.categoryId,
        expense.storeId != null ? storeById[expense.storeId]?.name ?? '' : '',
        expense.note ?? '',
        expense.source.name,
      ]);
    }

    final content = const ListToCsvConverter().convert(rows);

    return BackupCsvResult(content: content, rowCount: expenses.length);
  }
}

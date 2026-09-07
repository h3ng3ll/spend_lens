import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import '../backup_csv_codec.dart';

/// Result of a completed CSV export — the file the share sheet hands off,
/// plus the row count the `tCsv` ARB placeholder needs (never a hardcoded
/// mock value — design_spendlens.md §4.4).
class ExportCsvResult {
  final File file;
  final String filename;
  final int rowCount;

  const ExportCsvResult({
    required this.file,
    required this.filename,
    required this.rowCount,
  });
}

/// Builds the CSV spreadsheet export (design_spendlens.md §6/§9/§11) from
/// the [Expense] dataset, and writes it to a temp file for the share sheet.
class ExportCsvUseCase {
  final IExpenseLocalRepository _expenseLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;

  const ExportCsvUseCase({
    required IExpenseLocalRepository expenseLocalRepository,
    required ICategoryLocalRepository categoryLocalRepository,
    required IStoreLocalRepository storeLocalRepository,
  }) : this._(
         expenseLocalRepository,
         categoryLocalRepository,
         storeLocalRepository,
       );

  const ExportCsvUseCase._(
    this._expenseLocalRepository,
    this._categoryLocalRepository,
    this._storeLocalRepository,
  );

  Future<ExportCsvResult> call() async {
    final expenses = await _expenseLocalRepository.getAll();
    final categories = await _categoryLocalRepository.getAll();
    final stores = await _storeLocalRepository.getAll();

    final result = BackupCsvCodec.encode(
      expenses: expenses,
      categories: categories,
      stores: stores,
    );

    final directory = await getTemporaryDirectory();
    final filename =
        'spendlens_export_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File('${directory.path}/$filename');
    await file.writeAsString(result.content, flush: true);

    return ExportCsvResult(
      file: file,
      filename: filename,
      rowCount: result.rowCount,
    );
  }
}

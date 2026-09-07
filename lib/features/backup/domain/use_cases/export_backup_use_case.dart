import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import '../backup_json_codec.dart';
import '../models/backup_bundle/backup_bundle.dart';

/// Result of a completed JSON export — the file the share sheet hands off
/// (design_spendlens.md §6, `tBackup` ARB placeholder's `{filename}`).
class ExportBackupResult {
  final File file;
  final String filename;

  const ExportBackupResult({required this.file, required this.filename});
}

/// Builds the canonical JSON backup (design_spendlens.md §6/§9/§11) from
/// every repository this app has, and writes it to a temp file for the
/// share sheet to hand off.
///
/// Reads every dataset via a single one-shot `getAll()` per repository —
/// this is a WRITE-time snapshot for an export action, not displayed bloc
/// state, so it is not a hive_rules.md §9 violation (that rule governs
/// reactive screen state, not a one-shot export/import operation).
class ExportBackupUseCase {
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final IProductLocalRepository _productLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final IExpenseLocalRepository _expenseLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;

  const ExportBackupUseCase({
    required IReceiptLocalRepository receiptLocalRepository,
    required IReceiptItemLocalRepository receiptItemLocalRepository,
    required IProductLocalRepository productLocalRepository,
    required IStoreLocalRepository storeLocalRepository,
    required ICategoryLocalRepository categoryLocalRepository,
    required IExpenseLocalRepository expenseLocalRepository,
    required IPriceObservationLocalRepository priceObservationLocalRepository,
  }) : this._(
         receiptLocalRepository,
         receiptItemLocalRepository,
         productLocalRepository,
         storeLocalRepository,
         categoryLocalRepository,
         expenseLocalRepository,
         priceObservationLocalRepository,
       );

  const ExportBackupUseCase._(
    this._receiptLocalRepository,
    this._receiptItemLocalRepository,
    this._productLocalRepository,
    this._storeLocalRepository,
    this._categoryLocalRepository,
    this._expenseLocalRepository,
    this._priceObservationLocalRepository,
  );

  Future<BackupBundle> buildBundle() async {
    final now = DateTime.now();

    return BackupBundle(
      schemaVersion: BackupJsonCodec.currentSchemaVersion,
      exportedAt: now,
      receipts: await _receiptLocalRepository.getAll(),
      receiptItems: await _receiptItemLocalRepository.getAll(),
      products: await _productLocalRepository.getAll(),
      stores: await _storeLocalRepository.getAll(),
      categories: await _categoryLocalRepository.getAll(),
      expenses: await _expenseLocalRepository.getAll(),
      priceObservations: await _priceObservationLocalRepository.getAll(),
    );
  }

  Future<ExportBackupResult> call() async {
    final bundle = await buildBundle();
    final json = BackupJsonCodec.encode(bundle);

    final directory = await getTemporaryDirectory();
    final filename =
        'spendlens_backup_${bundle.exportedAt.millisecondsSinceEpoch}.json';
    final file = File('${directory.path}/$filename');
    await file.writeAsString(json, flush: true);

    return ExportBackupResult(file: file, filename: filename);
  }
}

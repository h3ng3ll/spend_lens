import '../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../../../settings/domain/repositories/i_settings_local_repository.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import '../backup_json_codec.dart';
import '../models/backup_bundle/backup_bundle.dart';

/// The outcome of a completed import, for the confirmation the caller shows
/// the user after the write completes.
class ImportBackupResult {
  final int receiptCount;
  final int expenseCount;

  const ImportBackupResult({
    required this.receiptCount,
    required this.expenseCount,
  });
}

/// Restores a backup produced by [ExportBackupUseCase]
/// (design_spendlens.md §6/§9/§11).
///
/// **Never blind-overwrites (spec §61).** The raw string is decoded through
/// [BackupJsonCodec.decode] FIRST — which validates the schema and migrates
/// an older shape forward, or throws [BackupSchemaTooNewException] /
/// [BackupMalformedException] before a single Hive write happens. Only a
/// bundle that survives that gate reaches [call]'s writes below, and every
/// write is a `save()` keyed by the record's own `id` — an import therefore
/// MERGES by id (an existing record with the same id is updated in place;
/// every other existing record is left untouched) rather than clearing the
/// boxes first, so a partial/older backup can never wipe data merely by
/// omitting it.
///
/// **Resets `AppSettings.dataCleared` back to `false`**
/// (`~/.claude/rules/delete_all_records_rules.md` — "any restore path sets
/// the flag back to `false`"). Without this, a user who ran "Delete all
/// records" and then imports a backup would see the import's own writes
/// silently ignored by the seed guard's `!dataCleared` check on the NEXT
/// cold start, and every future first-launch seed would stay suppressed —
/// the app would forever believe itself deliberately emptied.
class ImportBackupUseCase {
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final IProductLocalRepository _productLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final IExpenseLocalRepository _expenseLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;
  final ISettingsLocalRepository _settingsLocalRepository;

  const ImportBackupUseCase({
    required IReceiptLocalRepository receiptLocalRepository,
    required IReceiptItemLocalRepository receiptItemLocalRepository,
    required IProductLocalRepository productLocalRepository,
    required IStoreLocalRepository storeLocalRepository,
    required ICategoryLocalRepository categoryLocalRepository,
    required IExpenseLocalRepository expenseLocalRepository,
    required IPriceObservationLocalRepository priceObservationLocalRepository,
    required ISettingsLocalRepository settingsLocalRepository,
  }) : this._(
         receiptLocalRepository,
         receiptItemLocalRepository,
         productLocalRepository,
         storeLocalRepository,
         categoryLocalRepository,
         expenseLocalRepository,
         priceObservationLocalRepository,
         settingsLocalRepository,
       );

  const ImportBackupUseCase._(
    this._receiptLocalRepository,
    this._receiptItemLocalRepository,
    this._productLocalRepository,
    this._storeLocalRepository,
    this._categoryLocalRepository,
    this._expenseLocalRepository,
    this._priceObservationLocalRepository,
    this._settingsLocalRepository,
  );

  /// Throws [BackupSchemaTooNewException] or [BackupMalformedException] when
  /// [raw] fails validation — the caller shows an error and writes nothing.
  Future<ImportBackupResult> call(String raw) async {
    final bundle = BackupJsonCodec.decode(raw);
    return applyBundle(bundle);
  }

  /// Writes an ALREADY-VALIDATED [bundle] (decoded via
  /// [BackupJsonCodec.decode] by the caller — e.g. `BackupBloc`, which
  /// validates on file-pick and applies only after the user confirms).
  Future<ImportBackupResult> applyBundle(BackupBundle bundle) async {
    for (final store in bundle.stores) {
      await _storeLocalRepository.save(store);
    }
    for (final category in bundle.categories) {
      await _categoryLocalRepository.save(category);
    }
    for (final product in bundle.products) {
      await _productLocalRepository.save(product);
    }
    for (final receipt in bundle.receipts) {
      await _receiptLocalRepository.save(receipt);
    }
    for (final item in bundle.receiptItems) {
      await _receiptItemLocalRepository.save(item);
    }
    for (final expense in bundle.expenses) {
      await _expenseLocalRepository.save(expense);
    }
    for (final observation in bundle.priceObservations) {
      await _priceObservationLocalRepository.save(observation);
    }

    // delete_all_records_rules.md: a restore path MUST clear the flag, or
    // the seed guard (`isEmpty && !dataCleared`) stays permanently tripped.
    final settings = await _settingsLocalRepository.get();
    if (settings.dataCleared) {
      await _settingsLocalRepository.save(
        settings.copyWith(dataCleared: false),
      );
    }

    return ImportBackupResult(
      receiptCount: bundle.receipts.length,
      expenseCount: bundle.expenses.length,
    );
  }
}

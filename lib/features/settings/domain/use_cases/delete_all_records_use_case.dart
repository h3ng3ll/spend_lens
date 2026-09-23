import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../models/e_delete_scope.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import '../repositories/i_settings_local_repository.dart';

/// "Delete all records" (design_spendlens.md §7 /
/// `~/.claude/rules/delete_all_records_rules.md`).
///
/// Clears every user-entered dataset this app currently has (M5: expenses,
/// custom stores, and CUSTOM categories only) then persists
/// `AppSettings.dataCleared = true` so the seed guard
/// (`isEmpty && !dataCleared`, see `SeedCategoriesUseCase`) never silently
/// repopulates the app on the next cold start. **Never re-seeds here.**
///
/// R2-9 correction: the built-in categories are **preserved**, matching the
/// design source's own `confirmDeleteAll` (`SpendLens Prototype.dc.html`
/// line 901), which clears only `customCats`, while
/// `allCats = [...defaultCats, ...customCats]` (line 808) keeps
/// `defaultCats` — a hardcoded constant — intact. The built-ins surviving
/// delete-all IS the design's own restore path; deleting them (the previous
/// behavior of this use case) produced the exact contradiction QA observed:
/// zero categories left while the destructive-action footer still states
/// "Built-in categories cannot be deleted." This does not add a new restore
/// flow — it stops removing data the design never asked this action to
/// remove.
///
/// ## It clears ALL SEVEN record collections
///
/// It used to clear three — expenses, stores and custom categories — because
/// M5 was manual-entry only and the others genuinely held nothing. M8 brought
/// scanning, and the dependency list was never extended: receipts, receipt
/// items, products and price observations all survived "delete all data".
/// The visible symptom was cloud storage still reporting megabytes of receipt
/// photos after the user had emptied the app, because the `Receipt` rows
/// naming those photos were never tombstoned.
///
/// ## It also empties the bucket
///
/// Tombstones only ever remove Firestore DOCUMENTS. Receipt photos, store
/// logos and product photos are Storage objects that nothing in the sync
/// cycle deletes, so the Profile storage bar kept reporting megabytes after
/// every record was gone. [FirebaseStorageService.deleteRecordFiles] now
/// sweeps them FIRST — before the tombstones trigger the sync whose
/// `usedBytes` re-measurement the bar shows.
class DeleteAllRecordsUseCase {
  final IExpenseLocalRepository _expenseLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final IProductLocalRepository _productLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;
  final ISettingsLocalRepository _settingsLocalRepository;
  final FirebaseStorageService _storageService;
  final LoggerService _loggerService;

  const DeleteAllRecordsUseCase({
    required IExpenseLocalRepository expenseLocalRepository,
    required IStoreLocalRepository storeLocalRepository,
    required ICategoryLocalRepository categoryLocalRepository,
    required IReceiptLocalRepository receiptLocalRepository,
    required IReceiptItemLocalRepository receiptItemLocalRepository,
    required IProductLocalRepository productLocalRepository,
    required IPriceObservationLocalRepository priceObservationLocalRepository,
    required ISettingsLocalRepository settingsLocalRepository,
    required FirebaseStorageService storageService,
    required LoggerService loggerService,
  }) : this._(
         expenseLocalRepository,
         storeLocalRepository,
         categoryLocalRepository,
         receiptLocalRepository,
         receiptItemLocalRepository,
         productLocalRepository,
         priceObservationLocalRepository,
         settingsLocalRepository,
         storageService,
         loggerService,
       );

  const DeleteAllRecordsUseCase._(
    this._expenseLocalRepository,
    this._storeLocalRepository,
    this._categoryLocalRepository,
    this._receiptLocalRepository,
    this._receiptItemLocalRepository,
    this._productLocalRepository,
    this._priceObservationLocalRepository,
    this._settingsLocalRepository,
    this._storageService,
    this._loggerService,
  );

  /// Tombstones every record in [scope].
  ///
  /// Deleting is a SOFT delete now, so this always produces tombstones — the
  /// difference between the scopes is what happens to them:
  ///
  /// **No caller passes a scope today.** `SettingsBloc` invokes this with no
  /// argument, so every "Delete all data" runs as [EDeleteScope.local] — which
  /// is what the confirm dialog promises ("Cloud backups are not affected"),
  /// so the behaviour is correct, but [EDeleteScope.clearsRemote] is currently
  /// dead. Wiring a scope CHOICE into that dialog is a UI decision that has
  /// not been made; the parameter is kept because the remote path below is
  /// already implemented and would otherwise have to be rebuilt.
  ///
  /// * [EDeleteScope.local] also sets `dataCleared`, which gates the pull so
  ///   the surviving cloud copy cannot flow back in.
  /// * [EDeleteScope.remote] leaves `dataCleared` alone; the tombstones are
  ///   pushed, removing the records from the account and other devices, and
  ///   this device's rows go with them (a tombstone is not visible locally
  ///   either — see the note below).
  /// * [EDeleteScope.both] does both.
  ///
  /// Note the honest limitation: because one soft delete drives both
  /// outcomes, a `remote` wipe also hides the rows on this device. Keeping
  /// them locally while deleting them remotely would need a second,
  /// local-only record state that nothing else in the app has. That is
  /// called out rather than faked.
  ///
  /// [uid] is empty when the user is signed out — nothing was ever uploaded
  /// under a uid, so the bucket sweep is skipped.
  Future<void> call({
    required String uid,
    EDeleteScope scope = EDeleteScope.local,
  }) async {
    await _deleteRemoteFiles(uid);

    final expenses = await _expenseLocalRepository.getAllIncludingDeleted();
    for (final expense in expenses) {
      await _expenseLocalRepository.delete(expense.id);
    }

    final stores = await _storeLocalRepository.getAllIncludingDeleted();
    for (final store in stores) {
      await _storeLocalRepository.delete(store.id);
    }

    final categories = await _categoryLocalRepository.getAllIncludingDeleted();
    for (final category in categories) {
      // Built-in categories survive delete-all by design (see the doc
      // comment above) — only user-created ones are cleared.
      if (category.isBuiltIn) continue;
      await _categoryLocalRepository.delete(category.id);
    }

    // The scanning-era collections. Absent until M8 and never added to this
    // list afterwards, which is what left receipt photos in cloud storage
    // after the user had emptied the app.
    final receipts = await _receiptLocalRepository.getAllIncludingDeleted();
    for (final receipt in receipts) {
      await _receiptLocalRepository.delete(receipt.id);
    }

    final receiptItems =
        await _receiptItemLocalRepository.getAllIncludingDeleted();
    for (final item in receiptItems) {
      await _receiptItemLocalRepository.delete(item.id);
    }

    final products = await _productLocalRepository.getAllIncludingDeleted();
    for (final product in products) {
      await _productLocalRepository.delete(product.id);
    }

    // `delete`, NOT `deleteLocalOnly`: a hard delete leaves no tombstone, so
    // the push pass never learns the rows are gone and every observation
    // stays in Firestore's `priceObservations` after "Delete all data".
    final observations =
        await _priceObservationLocalRepository.getAllIncludingDeleted();
    for (final observation in observations) {
      await _priceObservationLocalRepository.delete(observation.id);
    }

    // `dataCleared` is what stops the seed AND (once sync lands) the pull
    // from repopulating. Only a scope that clears this device sets it: a
    // remote-only wipe must leave the flag alone.
    if (scope.clearsLocal) {
      final settings = await _settingsLocalRepository.get();
      await _settingsLocalRepository.save(
        settings.copyWith(dataCleared: true),
      );
    }
  }

  /// Swallowed on failure, like `DeleteStoreUseCase._deleteLogo`: an
  /// offline or transient Storage error must not abort the local wipe the
  /// user confirmed. The orphan is a quota cost, and a later delete-all
  /// retries the sweep because it reads the bucket, not local rows.
  Future<void> _deleteRemoteFiles(String uid) async {
    if (uid.isEmpty) return;
    try {
      await _storageService.deleteRecordFiles(uid);
    } catch (error, stackTrace) {
      _loggerService.error(
        'Delete-all: bucket sweep failed',
        error: error,
        stackTrace: stackTrace,
        name: 'Settings',
      );
    }
  }
}

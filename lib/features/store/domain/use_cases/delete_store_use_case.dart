import '../../../../core/services/firebase/firebase_storage_service.dart';
import '../../../../core/services/store_logo_image_store/store_logo_image_store.dart';
import '../../../analytics/domain/repositories/i_price_observation_local_repository.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_item_local_repository.dart';
import '../../../receipt/domain/repositories/i_receipt_local_repository.dart';
import '../repositories/i_store_local_repository.dart';

/// How much a store delete would take with it. Counted BEFORE the write so
/// the confirmation can state the real consequence instead of a generic
/// warning — the user is told "7 expenses" because seven rows were actually
/// found, never because the copy guessed.
class StoreDeleteImpact {
  final int expenses;
  final int receipts;

  const StoreDeleteImpact({required this.expenses, required this.receipts});

  /// Whether anything besides the store itself would be removed. Drives the
  /// confirmation copy; a store nothing references deletes silently.
  bool get hasRecords => expenses > 0 || receipts > 0;
}

/// Deletes a store AND every record that points at it
/// (design_spendlens.md's Stores artboard, `storeCanDelete` block).
///
/// The delete control used to hide itself whenever any expense referenced
/// the store, so a store that had ever been used could not be removed at
/// all — `StoreDeleteSection` returned `SizedBox.shrink()` and the feature
/// looked absent. The button is now always offered; this use case is what
/// makes that safe, by owning the cascade the old guard existed to avoid.
///
/// **Everything is a SOFT delete**, exactly as `DeleteAllRecordsUseCase`
/// does it: each repository's `delete` stamps `deletedAt` +
/// `pendingDelete`, so the removal propagates to the account and to other
/// devices. A hard `box.delete` here would leave no tombstone and the next
/// pull would resurrect every row.
///
/// Order matters. Children are tombstoned BEFORE the store, so an
/// interruption (a crash, a killed process) can only ever leave orphaned
/// CHILDREN of a store that still exists — recoverable, and invisible to
/// the user. Deleting the store first would leave expenses pointing at a
/// store id that no longer resolves, which is the dangling reference the
/// original guard was protecting against.
///
/// **The LOGO is removed too — the record tombstone cannot do it.** A soft
/// delete propagates through Firestore, but a Storage object is not a
/// Firestore document: nothing in the sync cycle ever touches the bucket on
/// a delete. Without the cleanup here, deleting a store left its logo in
/// `users/{uid}/stores/{id}.jpg` forever — consuming the user's quota, with
/// no record left anywhere that names it, so no code path could ever find
/// it again. The user's report was exactly that: cloud usage went up when a
/// logo was added and never came back down.
///
/// The image step runs FIRST and its failure is swallowed. A logo that
/// cannot be deleted (offline, a transient Storage error) must not abort the
/// record cascade the user actually asked for — the alternative is a
/// half-deleted store whose expenses are gone and whose row remains. The
/// orphan is a quota cost, not a correctness one, and `deleteStoreLogo`
/// already treats already-gone as success so a later retry is safe.
class DeleteStoreUseCase {
  final IStoreLocalRepository _storeLocalRepository;
  final IExpenseLocalRepository _expenseLocalRepository;
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;
  final StoreLogoImageStore _imageStore;
  final FirebaseStorageService _storageService;

  const DeleteStoreUseCase({
    required IStoreLocalRepository storeLocalRepository,
    required IExpenseLocalRepository expenseLocalRepository,
    required IReceiptLocalRepository receiptLocalRepository,
    required IReceiptItemLocalRepository receiptItemLocalRepository,
    required IPriceObservationLocalRepository priceObservationLocalRepository,
    required StoreLogoImageStore imageStore,
    required FirebaseStorageService storageService,
  }) : this._(
         storeLocalRepository,
         expenseLocalRepository,
         receiptLocalRepository,
         receiptItemLocalRepository,
         priceObservationLocalRepository,
         imageStore,
         storageService,
       );

  const DeleteStoreUseCase._(
    this._storeLocalRepository,
    this._expenseLocalRepository,
    this._receiptLocalRepository,
    this._receiptItemLocalRepository,
    this._priceObservationLocalRepository,
    this._imageStore,
    this._storageService,
  );

  /// Counts what [call] would remove, WITHOUT removing anything.
  ///
  /// Read-only on purpose: the confirmation dialog needs the numbers before
  /// the user has agreed to anything.
  Future<StoreDeleteImpact> impact(String storeId) async {
    final expenses = await _expenseLocalRepository.getAll();
    final receipts = await _receiptLocalRepository.getAll();

    return StoreDeleteImpact(
      expenses: expenses.where((e) => e.storeId == storeId).length,
      receipts: receipts.where((r) => r.storeId == storeId).length,
    );
  }

  /// Tombstones every record referencing [storeId], then the store itself,
  /// after removing the store's logo from disk and from the bucket.
  ///
  /// [uid] is empty when the user is signed out — nothing was ever uploaded
  /// under a uid, so only the local file is removed.
  Future<void> call(String storeId, {required String uid}) async {
    await _deleteLogo(storeId, uid);

    final receipts = await _receiptLocalRepository.getAll();
    final storeReceipts = receipts
        .where((receipt) => receipt.storeId == storeId)
        .toList();

    // Receipt items hang off a receipt, and the link points DOWNWARD:
    // `Receipt.itemIds` holds them, because `ReceiptItem` carries no
    // `receiptId` of its own. They must therefore be collected from the
    // receipts being removed — skipping this would strand every line item
    // of a deleted receipt in the box forever, invisible and unreachable.
    for (final receipt in storeReceipts) {
      for (final itemId in receipt.itemIds) {
        await _receiptItemLocalRepository.delete(itemId);
      }
    }

    // Price observations carry `storeId` directly AND are the source of
    // every cross-store price comparison. Leaving them behind would keep
    // the deleted store quietly influencing "cheaper at ..." lines on other
    // stores' detail screens.
    final observations = await _priceObservationLocalRepository.getAll();
    for (final observation in observations) {
      if (observation.storeId == storeId) {
        await _priceObservationLocalRepository.delete(observation.id);
      }
    }

    for (final receipt in storeReceipts) {
      await _receiptLocalRepository.delete(receipt.id);
    }

    final expenses = await _expenseLocalRepository.getAll();
    for (final expense in expenses) {
      if (expense.storeId == storeId) {
        await _expenseLocalRepository.delete(expense.id);
      }
    }

    // The store last: see the ordering note in the class doc.
    await _storeLocalRepository.delete(storeId);
  }

  /// Removes the store's logo file and its remote object.
  ///
  /// Reads the store to learn the stored FILENAME rather than deriving it:
  /// `logoFilename` is what the record actually points at, and a store saved
  /// before the current naming scheme would not match a derived name.
  Future<void> _deleteLogo(String storeId, String uid) async {
    try {
      final store = await _storeLocalRepository.getById(storeId);
      await _imageStore.delete(store?.logoFilename);

      if (uid.isNotEmpty) {
        await _storageService.deleteStoreLogo(uid: uid, storeId: storeId);
      }
    } catch (_) {
      // Swallowed on purpose — see the class doc. The record cascade is what
      // the user asked for and must not be lost to an image failure.
    }
  }
}

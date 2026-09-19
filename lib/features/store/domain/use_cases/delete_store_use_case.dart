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
class DeleteStoreUseCase {
  final IStoreLocalRepository _storeLocalRepository;
  final IExpenseLocalRepository _expenseLocalRepository;
  final IReceiptLocalRepository _receiptLocalRepository;
  final IReceiptItemLocalRepository _receiptItemLocalRepository;
  final IPriceObservationLocalRepository _priceObservationLocalRepository;

  const DeleteStoreUseCase({
    required IStoreLocalRepository storeLocalRepository,
    required IExpenseLocalRepository expenseLocalRepository,
    required IReceiptLocalRepository receiptLocalRepository,
    required IReceiptItemLocalRepository receiptItemLocalRepository,
    required IPriceObservationLocalRepository priceObservationLocalRepository,
  }) : this._(
         storeLocalRepository,
         expenseLocalRepository,
         receiptLocalRepository,
         receiptItemLocalRepository,
         priceObservationLocalRepository,
       );

  const DeleteStoreUseCase._(
    this._storeLocalRepository,
    this._expenseLocalRepository,
    this._receiptLocalRepository,
    this._receiptItemLocalRepository,
    this._priceObservationLocalRepository,
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

  /// Tombstones every record referencing [storeId], then the store itself.
  Future<void> call(String storeId) async {
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
}

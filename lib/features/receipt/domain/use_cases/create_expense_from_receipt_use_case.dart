import '../../../expense/domain/models/expense/e_expense_source.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../models/receipt/receipt.dart';

/// The built-in category a receipt is filed under when the user saved it
/// without picking one.
///
/// `Expense.categoryId` is REQUIRED, but Review's category row is optional
/// and its Save button is deliberately always enabled (the design's
/// `saveReceipt` has no category gate). Something therefore has to stand in,
/// and `catOther` is the seeded built-in that exists for exactly this
/// purpose (`SeedCategoriesUseCase`) — never a blank id, which would render
/// as a missing category on Home and History.
const String kUncategorizedCategoryId = 'catOther';

/// Creates the [Expense] record that makes a saved [Receipt] visible to the
/// rest of the app (design_spendlens.md §3).
///
/// **Why this exists.** Home, History and Analytics all read the `expenses`
/// box — none of them reads `receipts`. Saving a scanned receipt wrote
/// `Receipt` + `ReceiptItem` and stopped there, so the receipt persisted
/// correctly but was invisible on every screen, and a restart did not help
/// because nothing was missing from the boxes actually being watched. The
/// design system's prototype is explicit that both flows land in ONE list:
/// `saveReceipt` prepends `{type:'Receipt'}` and `saveCash` prepends
/// `{type:'Cash'}` to the same `tx` array that Home renders
/// (`assets/SpendLens design system/SpendLens Prototype.dc.html`), which is
/// precisely the distinction [EExpenseSource] encodes.
///
/// A use case rather than bloc code because the receipt→expense mapping is
/// domain policy (which amount is authoritative, what an uncategorized
/// receipt falls back to), and `ReviewBloc` already owns enough.
class CreateExpenseFromReceiptUseCase {
  final IExpenseLocalRepository _repository;

  const CreateExpenseFromReceiptUseCase(this._repository);

  /// Writes one [Expense] mirroring [receipt].
  ///
  /// The amount follows the design's own rule — `num(s.printedTotal) ||
  /// itemsTotalNum` — - the PRINTED total when the parser read one, else the
  /// sum of the item lines. The printed total is preferred because it is
  /// what the shop charged: it accounts for rounding and any discount the
  /// item lines do not carry.
  ///
  /// The expense shares the receipt's `id`, so the two records are linked
  /// without adding a `receiptId` field to [Expense]: History's
  /// `RecordDetailBloc` looks a record up by id, and a receipt-sourced row
  /// must resolve to the receipt it came from.
  Future<void> call({required Receipt receipt, String? storeId}) async {
    final amount = receipt.printedTotal ?? receipt.itemsTotal;

    await _repository.save(
      Expense(
        id: receipt.id,
        amount: amount,
        currencyCode: receipt.currencyCode,
        categoryId: receipt.categoryId ?? kUncategorizedCategoryId,
        storeId: storeId,
        occurredAt: receipt.purchasedAt,
        source: EExpenseSource.receipt,
        updatedAt: receipt.updatedAt,
        syncStatus: receipt.syncStatus,
      ),
    );
  }
}

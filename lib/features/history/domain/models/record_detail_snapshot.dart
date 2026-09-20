import '../../../product/domain/models/product/product.dart';
import '../../../category/domain/models/category/category.dart';
import '../../../expense/domain/models/expense/expense.dart';
import '../../../receipt/domain/models/receipt/receipt.dart';
import '../../../receipt/domain/models/receipt_item/receipt_item.dart';
import '../../../store/domain/models/store/store.dart';

/// Named snapshot class combining the streams [RecordDetailBloc] reacts to
/// (hive_rules.md §7/§10 — never a Dart record type for a combined-stream
/// value; mirrors `StoreDetailSnapshot`'s shape).
///
/// [expense] is null once the record this screen was opened for no longer
/// exists (deleted by this same screen, or from elsewhere while it was
/// still mounted) — the bloc maps that to `ERecordDetailStatus.notFound`
/// rather than treating a missing record as a failure.
///
/// [receipt] and [items] carry the receipt-sourced branch of the design's
/// Record detail artboard (the Items card and the Receipt photo card).
/// Both are resolved by id identity: `CreateExpenseFromReceiptUseCase`
/// deliberately writes the mirrored [Expense] with `id: receipt.id`, so the
/// `recordId` this screen is opened with resolves BOTH records. They stay
/// null/empty for a cash expense, which has no receipt behind it.
class RecordDetailSnapshot {
  final Expense? expense;
  final List<Category> categories;
  final List<Store> stores;

  /// The receipt this record came from, or null for a cash expense.
  final Receipt? receipt;

  /// [receipt]'s line items, ordered by `lineIndex` (print order). Empty
  /// for a cash expense, and also for a receipt saved with no items.
  final List<ReceiptItem> items;

  /// The products the items resolve to, so a line can show its product's
  /// CURRENT name rather than the copy stamped on it at save time.
  final List<Product> products;

  const RecordDetailSnapshot({
    required this.expense,
    required this.categories,
    required this.stores,
    this.receipt,
    this.items = const <ReceiptItem>[],
      required this.products,
});
}

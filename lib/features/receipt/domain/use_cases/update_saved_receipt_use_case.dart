import '../../../../core/models/e_sync_status.dart';
import '../../../product/domain/normalizer/product_normalizer.dart';
import '../../../product/domain/repositories/i_product_local_repository.dart';
import '../models/receipt/receipt.dart';
import '../models/receipt_item/receipt_item.dart';
import '../repositories/i_receipt_item_local_repository.dart';
import '../repositories/i_receipt_local_repository.dart';
import 'create_expense_from_receipt_use_case.dart';
import 'save_scanned_receipt_use_case.dart';

/// The corrections to apply to an ALREADY-SAVED receipt.
///
/// Reuses [ScannedReceiptItemInput] for its lines — the two save paths differ
/// in their sync status and in where the receipt comes from, never in what a
/// line is.
class SavedReceiptCorrections {
  final String receiptId;
  final List<ScannedReceiptItemInput> items;
  final String? storeId;
  final DateTime? purchasedAt;
  final double? printedTotal;
  final double itemsTotal;
  final bool matchesTotal;

  const SavedReceiptCorrections({
    required this.receiptId,
    required this.items,
    required this.storeId,
    required this.purchasedAt,
    required this.printedTotal,
    required this.itemsTotal,
    required this.matchesTotal,
  });
}

/// Thrown when the receipt being corrected no longer exists.
///
/// A distinct type rather than a bool/null return so the bloc can map it to
/// its own `receipt_not_found` message without inspecting a sentinel.
class ReceiptNotFoundFailure implements Exception {
  const ReceiptNotFoundFailure();
}

/// Writes corrections back onto a receipt that is already in Hive.
///
/// The counterpart to [SaveScannedReceiptUseCase], which creates one. Both are
/// use cases for the same reason: every rule here is domain policy — that a
/// manually-added line's typed name becomes its `rawName` while an OCR line's
/// is never touched (spec §11), and that the mirrored expense must be rewritten
/// or the edit is invisible to every screen.
///
/// `EditReceiptBloc` previously inlined all of it, so ~110 lines of persistence
/// rules lived in a presentation class where no test could reach them without
/// building a bloc.
class UpdateSavedReceiptUseCase {
  final IReceiptLocalRepository _receiptRepository;
  final IReceiptItemLocalRepository _receiptItemRepository;
  final IProductLocalRepository _productRepository;
  final CreateExpenseFromReceiptUseCase _createExpenseFromReceipt;
  final ProductNormalizer _productNormalizer;
  final DateTime Function() _now;

  const UpdateSavedReceiptUseCase({
    required IReceiptLocalRepository receiptRepository,
    required IReceiptItemLocalRepository receiptItemRepository,
    required IProductLocalRepository productRepository,
    required CreateExpenseFromReceiptUseCase createExpenseFromReceipt,
    ProductNormalizer productNormalizer = const ProductNormalizer(),
    DateTime Function() now = DateTime.now,
  }) : this._(
         receiptRepository,
         receiptItemRepository,
         productRepository,
         createExpenseFromReceipt,
         productNormalizer,
         now,
       );

  const UpdateSavedReceiptUseCase._(
    this._receiptRepository,
    this._receiptItemRepository,
    this._productRepository,
    this._createExpenseFromReceipt,
    this._productNormalizer,
    this._now,
  );

  /// Applies [corrections], or throws [ReceiptNotFoundFailure] when the
  /// receipt is gone.
  Future<void> call(SavedReceiptCorrections corrections) async {
    final now = _now();
    final existing = await _receiptRepository.getById(corrections.receiptId);
    if (existing == null) throw const ReceiptNotFoundFailure();

    final itemIds = await _persistItems(corrections, now);

    final updatedReceipt = existing.copyWith(
      storeId: corrections.storeId,
      purchasedAt: corrections.purchasedAt ?? existing.purchasedAt,
      printedTotal: corrections.printedTotal,
      itemsTotal: corrections.itemsTotal,
      itemIds: itemIds,
      isReconciled: corrections.matchesTotal,
      updatedAt: now,
      syncStatus: ESyncStatus.pendingUpdate,
    );
    await _receiptRepository.save(updatedReceipt);

    await _mirrorToExpense(updatedReceipt);
  }

  Future<List<String>> _persistItems(
    SavedReceiptCorrections corrections,
    DateTime now,
  ) async {
    final existingProducts = await _productRepository.getAll();
    final mutableProducts = List.of(existingProducts);

    final itemIds = <String>[];
    for (var i = 0; i < corrections.items.length; i++) {
      final draftItem = corrections.items[i];
      final isManuallyAdded = draftItem.rawName.isEmpty;

      final matchResult = _productNormalizer.normalize(
        rawName: draftItem.name,
        existingProducts: mutableProducts,
        generateId: () => '${now.microsecondsSinceEpoch}_product_$i',
        defaultUnit: draftItem.unit,
        storeId: corrections.storeId,
      );
      if (matchResult.isNewProduct) {
        mutableProducts.add(matchResult.product);
        await _productRepository.save(matchResult.product);
      }

      final item = ReceiptItem(
        id: draftItem.id,
        // A manually-added row has no OCR origin — its rawName is its typed
        // name, set ONCE here at creation. An OCR-derived row keeps its
        // ORIGINAL rawName untouched (spec §11) — never the edited `name`.
        rawName: isManuallyAdded ? draftItem.name : draftItem.rawName,
        normalizedName: matchResult.product.displayName,
        productId: matchResult.product.id,
        quantity: draftItem.quantity,
        unit: draftItem.unit,
        lineTotal: draftItem.lineTotal,
        // A corrected line is confirmed by the user either way, so both
        // branches are certain — kept explicit rather than collapsed, because
        // the two carry different meanings even at the same value.
        confidence: 1.0,
        isManuallyAdded: isManuallyAdded,
        lineIndex: i,
        updatedAt: now,
        syncStatus: ESyncStatus.pendingUpdate,
      );
      await _receiptItemRepository.save(item);
      itemIds.add(item.id);
    }

    return itemIds;
  }

  /// Mirrors the receipt into the `expenses` box.
  ///
  /// Home, History and Analytics all watch `expenses` and NONE of them reads
  /// `receipts`, so a receipt saved without this is invisible everywhere — the
  /// app still shows "No expenses yet" right after a successful save, and a
  /// restart does not help because nothing is missing from the boxes actually
  /// being watched.
  ///
  /// This covers BOTH ways a receipt reaches the edit screen:
  ///
  /// - MANUAL ENTRY (scan failed → "Enter Manually"): `ScannerBody` writes a
  ///   blank `Receipt` so the editor has a record to load, but nothing ever
  ///   created its `Expense`.
  /// - EDITING an already-saved receipt: the mirrored expense existed but went
  ///   stale, since amount/date/store changes stopped at the `Receipt`.
  ///
  /// Idempotent by construction: the use case writes with `id: receipt.id` and
  /// `save` overwrites at that key, so the create and the update are the same
  /// call.
  Future<void> _mirrorToExpense(Receipt receipt) {
    return _createExpenseFromReceipt(
      receipt: receipt,
      storeId: receipt.storeId,
    );
  }
}

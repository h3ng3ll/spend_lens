import '../../../../core/models/e_sync_status.dart';
import '../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../product/domain/models/product/e_unit.dart';
import '../../../product/domain/models/product/product.dart';
import '../../../product/domain/normalizer/product_match_result.dart';
import '../../../product/domain/normalizer/product_normalizer.dart';
import '../../../product/domain/use_cases/rename_product_use_case.dart';
import '../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../scanner/domain/pending_receipt_draft_store.dart';
import '../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../store/domain/use_cases/learn_store_alias_use_case.dart';
import '../models/receipt/receipt.dart';
import '../models/receipt_item/receipt_item.dart';
import '../repositories/i_receipt_item_local_repository.dart';
import '../repositories/i_receipt_local_repository.dart';
import 'create_expense_from_receipt_use_case.dart';
import 'record_price_observations_use_case.dart';

/// One reviewed scan, flattened to exactly what persistence needs.
///
/// A plain input object rather than `ReviewState`: the use case must not
/// depend on a presentation class, or the domain layer would import the bloc
/// it is being extracted from.
class ScannedReceiptInput {
  final List<ScannedReceiptItemInput> items;
  final String? storeId;

  /// The store name as PRINTED on the receipt — the alias candidate.
  final String? storeName;

  /// Whether [storeId] came from an explicit user pick. Gates alias learning.
  final bool isStoreUserPicked;

  final String? categoryId;
  final DateTime? purchasedAt;
  final double? printedTotal;
  final double itemsTotal;
  final bool isReconciled;
  final String? imageFilename;

  const ScannedReceiptInput({
    required this.items,
    required this.storeId,
    required this.storeName,
    required this.isStoreUserPicked,
    required this.categoryId,
    required this.purchasedAt,
    required this.printedTotal,
    required this.itemsTotal,
    required this.isReconciled,
    required this.imageFilename,
  });
}

/// One reviewed line, carrying BOTH names — see [rawName].
class ScannedReceiptItemInput {
  final String id;

  /// The parser's ORIGINAL text, preserved byte-for-byte (spec §11).
  final String rawName;

  /// The possibly user-edited display name, fed to the normalizer.
  final String name;

  final double quantity;
  final EUnit unit;
  final double? unitPrice;
  final double lineTotal;
  final double confidence;
  final bool isLowConfidence;
  final bool isManuallyAdded;

  const ScannedReceiptItemInput({
    required this.id,
    required this.rawName,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.lineTotal,
    required this.confidence,
    required this.isLowConfidence,
    required this.isManuallyAdded,
  });
}

/// Persists a reviewed scan: products, receipt items, the receipt, its
/// mirroring expense, the learned store alias, and the draft cleanup.
///
/// **Why this is a use case and not bloc code.** Every decision here is domain
/// policy, not screen behaviour: which name the normalizer sees, that `rawName`
/// is never overwritten, that an expense must mirror the receipt, that an alias
/// is only learned from an explicit pick. `ReviewBloc` previously inlined all of
/// it, which left ~120 lines of persistence rules in a presentation class where
/// no other caller could reach them and no test could exercise them without
/// constructing a bloc.
///
/// The bloc keeps what is genuinely its own: reading the draft, editing items,
/// and choosing which status follows a save.
class SaveScannedReceiptUseCase {
  final IReceiptLocalRepository _receiptRepository;
  final IReceiptItemLocalRepository _receiptItemRepository;
  final IProductLocalRepository _productRepository;
  final IStoreLocalRepository _storeRepository;
  final CreateExpenseFromReceiptUseCase _createExpenseFromReceipt;
  final RecordPriceObservationsUseCase _recordPriceObservations;
  final LearnStoreAliasUseCase _learnStoreAlias;
  final PendingReceiptDraftStore _draftStore;
  final ProductNormalizer _productNormalizer;
  final RenameProductUseCase _renameProduct;
  final ReceiptImageStore _imageStore;
  final DateTime Function() _now;

  const SaveScannedReceiptUseCase({
    required IReceiptLocalRepository receiptRepository,
    required IReceiptItemLocalRepository receiptItemRepository,
    required IProductLocalRepository productRepository,
    required IStoreLocalRepository storeRepository,
    required CreateExpenseFromReceiptUseCase createExpenseFromReceipt,
    required RecordPriceObservationsUseCase recordPriceObservations,
    required LearnStoreAliasUseCase learnStoreAlias,
    required PendingReceiptDraftStore draftStore,
    required RenameProductUseCase renameProduct,
    ProductNormalizer productNormalizer = const ProductNormalizer(),
    ReceiptImageStore imageStore = const ReceiptImageStore(),
    DateTime Function() now = DateTime.now,
  }) : this._(
         receiptRepository,
         receiptItemRepository,
         productRepository,
         storeRepository,
         createExpenseFromReceipt,
         recordPriceObservations,
         learnStoreAlias,
         draftStore,
         renameProduct,
         productNormalizer,
         imageStore,
         now,
       );

  const SaveScannedReceiptUseCase._(
    this._receiptRepository,
    this._receiptItemRepository,
    this._productRepository,
    this._storeRepository,
    this._createExpenseFromReceipt,
    this._recordPriceObservations,
    this._learnStoreAlias,
    this._draftStore,
    this._renameProduct,
    this._productNormalizer,
    this._imageStore,
    this._now,
  );

  /// Writes everything and returns the new receipt's id.
  Future<String> call(ScannedReceiptInput input) async {
    final now = _now();
    final receiptId = '${now.microsecondsSinceEpoch}';

    final receiptItems = await _persistItems(input, receiptId, now);
    final receipt = await _persistReceipt(input, receiptItems, receiptId, now);

    // Saving the `Receipt` alone made it INVISIBLE: Home, History and
    // Analytics all watch the `expenses` box and none of them reads
    // `receipts`, so a saved scan appeared nowhere and a restart did not help —
    // nothing was missing from the boxes actually being watched. The design's
    // prototype puts both flows in ONE list (`saveReceipt` prepends
    // `{type:'Receipt'}`, `saveCash` prepends `{type:'Cash'}` to the same `tx`
    // array Home renders), which is what `EExpenseSource` encodes.
    //
    // `storeId` is what makes the saved scan show up under its store: the
    // per-store screens aggregate `Expense.storeId`, and it was never passed,
    // so every scanned receipt landed store-less.
    await _createExpenseFromReceipt(receipt: receipt, storeId: input.storeId);

    // The product<->store edge. Without this the products and the store are
    // both saved but nothing joins them, so the Stores list counts 0 products
    // and "Products bought here" stays empty no matter how much is scanned.
    await _recordPriceObservations(
      receiptId: receiptId,
      storeId: input.storeId,
      items: receiptItems,
      observedAt: receipt.purchasedAt,
      currencyCode: receipt.currencyCode,
      now: now,
    );

    await _learnAlias(input);

    // The draft's job is done — clear it so a later, unrelated scan never
    // picks up a stale draft (see `PendingReceiptDraftStore` doc comment).
    _draftStore.clear();

    return receiptId;
  }

  /// Normalizes each line to a [Product] and writes the [ReceiptItem]s.
  Future<List<ReceiptItem>> _persistItems(
    ScannedReceiptInput input,
    String receiptId,
    DateTime now,
  ) async {
    final existingProducts = await _productRepository.getAll();
    final mutableProducts = List<Product>.of(existingProducts);

    final receiptItems = <ReceiptItem>[];
    for (var i = 0; i < input.items.length; i++) {
      final draftItem = input.items[i];

      // Normalizer pipeline: cleanup -> abbreviation -> exact -> fuzzy ->
      // create (spec §6/§42). A near-miss creates a new product rather than
      // merging — see `ProductNormalizer`/`ProductFuzzyMatcher`.
      final ProductMatchResult matchResult = _productNormalizer.normalize(
        rawName: draftItem.name,
        existingProducts: mutableProducts,
        generateId: () => '${now.microsecondsSinceEpoch}_product_$i',
        defaultUnit: draftItem.unit,
        storeId: input.storeId,
      );

      var product = matchResult.product;
      if (matchResult.isNewProduct) {
        mutableProducts.add(product);
        await _productRepository.save(product);
      } else {
        // A renamed line that MATCHED an existing product must carry its new
        // name onto that product, because a saved line is displayed by its
        // product's name (`receiptItemDisplayName`) — otherwise the
        // normalizer hands back the pre-rename product, `normalizedName`
        // below is set from that stale `displayName`, and the correction the
        // user typed is silently replaced by the text it was replacing.
        //
        // The rule lives in `RenameProductUseCase`, shared with
        // `EditReceiptBloc._onSave`.
        product = await _renameProduct(
          product: product,
          displayName: draftItem.name,
        );
        final renamedIndex = mutableProducts.indexWhere(
          (candidate) => candidate.id == product.id,
        );
        if (renamedIndex != -1) mutableProducts[renamedIndex] = product;
      }

      // `rawName` is set ONCE, at creation, from the item's ORIGINAL rawName
      // captured at parse time — never from the (possibly edited) `name`
      // field. This is the hardest invariant this milestone protects
      // (spec §11) and the exact reason the input keeps them as two fields.
      receiptItems.add(
        ReceiptItem(
          id: draftItem.id,
          rawName: draftItem.rawName,
          normalizedName: product.displayName,
          productId: product.id,
          quantity: draftItem.quantity,
          unit: draftItem.unit,
          unitPrice: draftItem.unitPrice,
          lineTotal: draftItem.lineTotal,
          confidence: draftItem.confidence,
          isLowConfidence: draftItem.isLowConfidence,
          isManuallyAdded: draftItem.isManuallyAdded,
          lineIndex: i,
          updatedAt: now,
          syncStatus: ESyncStatus.pendingCreate,
        ),
      );
    }

    for (final item in receiptItems) {
      await _receiptItemRepository.save(item);
    }

    return receiptItems;
  }

  Future<Receipt> _persistReceipt(
    ScannedReceiptInput input,
    List<ReceiptItem> receiptItems,
    String receiptId,
    DateTime now,
  ) async {
    // The capture is ALREADY on disk (the scan pipeline wrote it there so the
    // buffer could be released) — this only gives it the receipt's own stable
    // `receipt_<id>.jpg` name.
    final imagePath = await _imageStore.renameToReceipt(
      receiptId: receiptId,
      filename: input.imageFilename,
    );

    final receipt = Receipt(
      id: receiptId,
      storeId: input.storeId,
      purchasedAt: input.purchasedAt ?? now,
      printedTotal: input.printedTotal,
      itemsTotal: input.itemsTotal,
      currencyCode: 'MDL',
      categoryId: input.categoryId,
      imagePath: imagePath,
      itemIds: receiptItems.map((i) => i.id).toList(),
      isReconciled: input.isReconciled,
      updatedAt: now,
      syncStatus: ESyncStatus.pendingCreate,
    );

    await _receiptRepository.save(receipt);
    return receipt;
  }

  /// Records the printed spelling ONLY for a store the user picked themselves.
  /// An auto-match must not record its own guess as confirmed, or one wrong
  /// match would teach itself and repeat forever.
  ///
  /// Runs after the receipt is safely persisted, and failure is swallowed:
  /// this is an optimisation for the NEXT scan, and losing it must never fail
  /// a save the user has already been told succeeded.
  Future<void> _learnAlias(ScannedReceiptInput input) async {
    final storeId = input.storeId;
    if (!input.isStoreUserPicked || storeId == null) return;

    try {
      final store = await _storeRepository.getById(storeId);
      if (store == null) return;
      await _learnStoreAlias(store: store, printedName: input.storeName);
    } catch (_) {
      // Intentionally ignored — see the doc comment.
    }
  }
}

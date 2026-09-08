import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';
import '../../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../../product/domain/models/product/product.dart';
import '../../../../product/domain/normalizer/product_match_result.dart';
import '../../../../product/domain/normalizer/product_normalizer.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../scanner/domain/pending_receipt_draft_store.dart';
import '../../../domain/models/receipt/receipt.dart';
import '../../../domain/models/receipt_item/receipt_item.dart';
import '../../../domain/repositories/i_receipt_item_local_repository.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';
import '../../../domain/rules/receipt_duplicate_detector.dart';
import '../../../domain/rules/receipt_reconciler.dart';
import '../../../domain/use_cases/create_expense_from_receipt_use_case.dart';
import 'review_draft_item.dart';

part 'review_event.dart';

part 'review_state.dart';

part 'review_state_ext.dart';

part 'review_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `ReviewPage.initState`, closed in `dispose` — BLoC rule A3.8).
///
/// Loads the current scan's [PendingReceiptDraft] and lets the user correct
/// it before Save. `rawName` is preserved byte-for-byte from the parser's
/// output through every edit here — only [ReviewDraftItem.name] (which
/// becomes `ReceiptItem.normalizedName`) ever changes (spec §11, the
/// hardest invariant this milestone protects).
///
/// The reconciler WARNS on a printed-total/items-total mismatch but Save is
/// ALWAYS allowed (spec §45); the duplicate detector WARNS but never blocks
/// or auto-deletes (spec §46) — both are surfaced as plain state fields the
/// UI renders, never as a gate on `_onSave`.
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final PendingReceiptDraftStore _draftStore;
  final IReceiptLocalRepository _receiptRepository;
  final IReceiptItemLocalRepository _receiptItemRepository;
  final IProductLocalRepository _productRepository;
  final CreateExpenseFromReceiptUseCase _createExpenseFromReceipt;
  final ProductNormalizer _productNormalizer;
  final ReceiptReconciler _reconciler;
  final ReceiptDuplicateDetector _duplicateDetector;
  final ReceiptImageStore _imageStore;
  final DateTime Function() _now;

  ReviewBloc({
    required this._draftStore,
    required this._receiptRepository,
    required this._receiptItemRepository,
    required this._productRepository,
    required this._createExpenseFromReceipt,
    this._productNormalizer = const ProductNormalizer(),
    this._reconciler = const ReceiptReconciler(),
    this._duplicateDetector = const ReceiptDuplicateDetector(),
    this._imageStore = const ReceiptImageStore(),
    this._now = DateTime.now,
  }) : super(const ReviewState()) {
    on<_Load>(_onLoad);
    on<_StartEditItem>(_onStartEditItem);
    on<_CommitEditedName>(_onCommitEditedName);
    on<_StopEditItem>(_onStopEditItem);
    on<_SetCategory>(_onSetCategory);
    on<_Save>(_onSave);
    on<_SaveAndCorrect>(_onSaveAndCorrect);
  }

  Future<void> _onLoad(_Load event, Emitter<ReviewState> emit) async {
    emit(state.copyWith(status: EReviewStatus.loading));

    final draft = _draftStore.current;
    if (draft == null) {
      emit(
        state.copyWith(
          status: EReviewStatus.failed,
          errorMessage: 'no_pending_draft',
        ),
      );
      return;
    }

    final parsed = draft.parsedReceipt;
    final items = parsed.items
        .map(
          (candidate) => ReviewDraftItem(
            id: '${_now().microsecondsSinceEpoch}_${candidate.lineIndex}',
            rawName: candidate.rawName,
            name: candidate.rawName,
            quantity: candidate.quantity,
            unit: candidate.unit,
            unitPrice: candidate.unitPrice,
            lineTotal: candidate.lineTotal,
            confidence: candidate.confidence,
            isLowConfidence: candidate.confidence < 0.6,
          ),
        )
        .toList();

    final itemsTotal = items.fold(0.0, (sum, item) => sum + item.lineTotal);
    final reconciliation = _reconciler.reconcile(
      printedTotal: parsed.total,
      itemsTotal: itemsTotal,
    );

    final existingReceipts = await _receiptRepository.getAll();
    final likelyDuplicate = _duplicateDetector.findLikelyDuplicate(
      storeId: null,
      purchasedAt: parsed.purchasedAt ?? _now(),
      total: parsed.total ?? itemsTotal,
      existingReceipts: existingReceipts,
    );

    emit(
      state.copyWith(
        status: EReviewStatus.ready,
        storeName: parsed.storeName,
        purchasedAt: parsed.purchasedAt ?? _now(),
        printedTotal: parsed.total,
        items: items,
        isReconciled: reconciliation.matches,
        reconciliationDifference: reconciliation.difference,
        isLikelyDuplicate: likelyDuplicate != null,
        imageFilename: draft.imageFilename,
      ),
    );
  }

  void _onStartEditItem(_StartEditItem event, Emitter<ReviewState> emit) {
    emit(state.copyWith(editingItemId: event.itemId));
  }

  void _onCommitEditedName(
    _CommitEditedName event,
    Emitter<ReviewState> emit,
  ) {
    final editingId = state.editingItemId;
    if (editingId == null) return;

    final updatedItems = state.items.map((item) {
      if (item.id != editingId) return item;
      // `rawName` is NEVER touched here — only `name` (spec §11).
      return item.copyWith(name: event.name);
    }).toList();

    emit(state.copyWith(items: updatedItems));
  }

  void _onStopEditItem(_StopEditItem event, Emitter<ReviewState> emit) {
    emit(state.copyWith(editingItemId: null));
  }

  void _onSetCategory(_SetCategory event, Emitter<ReviewState> emit) {
    emit(state.copyWith(categoryId: event.categoryId));
  }

  Future<void> _onSave(_Save event, Emitter<ReviewState> emit) async {
    final receiptId = await _persist();
    emit(state.copyWith(status: EReviewStatus.saved, savedReceiptId: receiptId));
  }

  Future<void> _onSaveAndCorrect(
    _SaveAndCorrect event,
    Emitter<ReviewState> emit,
  ) async {
    final receiptId = await _persist();
    emit(
      state.copyWith(
        status: EReviewStatus.savedThenCorrect,
        savedReceiptId: receiptId,
      ),
    );
  }

  /// Shared persistence path for both [_onSave] and [_onSaveAndCorrect] —
  /// the two differ ONLY in which status/navigation follows, never in what
  /// gets written.
  Future<String> _persist() async {
    final now = _now();
    final receiptId = '${now.microsecondsSinceEpoch}';

    final existingProducts = await _productRepository.getAll();
    final mutableProducts = List<Product>.of(existingProducts);

    final receiptItems = <ReceiptItem>[];
    for (var i = 0; i < state.items.length; i++) {
      final draftItem = state.items[i];

      // Normalizer pipeline: cleanup -> abbreviation -> exact -> fuzzy ->
      // create (spec §6/§42). A near-miss creates a new product rather
      // than merging — see `ProductNormalizer`/`ProductFuzzyMatcher`.
      final ProductMatchResult matchResult = _productNormalizer.normalize(
        rawName: draftItem.name,
        existingProducts: mutableProducts,
        generateId: () =>
            '${now.microsecondsSinceEpoch}_product_$i',
        defaultUnit: draftItem.unit,
      );

      if (matchResult.isNewProduct) {
        mutableProducts.add(matchResult.product);
        await _productRepository.save(matchResult.product);
      }

      // `rawName` is set ONCE, at creation, from the item's ORIGINAL
      // rawName captured at parse time — never from the (possibly edited)
      // `name` field. This is the hardest invariant this milestone
      // protects (spec §11) and the exact reason `ReviewDraftItem` keeps
      // `rawName` and `name` as two separate fields.
      receiptItems.add(
        ReceiptItem(
          id: draftItem.id,
          rawName: draftItem.rawName,
          normalizedName: matchResult.product.displayName,
          productId: matchResult.product.id,
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

    // The capture is ALREADY on disk (the scan pipeline wrote it there so
    // the buffer could be released) — this only gives it the receipt's own
    // stable `receipt_<id>.jpg` name.
    final imagePath = await _imageStore.renameToReceipt(
      receiptId: receiptId,
      filename: state.imageFilename,
    );

    final itemsTotal = state.itemsTotal;
    final receipt = Receipt(
      id: receiptId,
      purchasedAt: state.purchasedAt ?? now,
      printedTotal: state.printedTotal,
      itemsTotal: itemsTotal,
      currencyCode: 'MDL',
      categoryId: state.categoryId,
      imagePath: imagePath,
      itemIds: receiptItems.map((i) => i.id).toList(),
      isReconciled: state.isReconciled,
      updatedAt: now,
      syncStatus: ESyncStatus.pendingCreate,
    );

    await _receiptRepository.save(receipt);

    // Saving the `Receipt` alone made it INVISIBLE: Home, History and
    // Analytics all watch the `expenses` box and none of them reads
    // `receipts`, so a saved scan appeared nowhere and a restart did not
    // help — nothing was missing from the boxes actually being watched.
    // The design's prototype puts both flows in ONE list (`saveReceipt`
    // prepends `{type:'Receipt'}`, `saveCash` prepends `{type:'Cash'}` to
    // the same `tx` array Home renders), which is what `EExpenseSource`
    // encodes.
    await _createExpenseFromReceipt(receipt: receipt);

    // The draft's job is done — clear it so a later, unrelated scan never
    // picks up a stale draft (see `PendingReceiptDraftStore` doc comment).
    _draftStore.clear();

    return receiptId;
  }
}

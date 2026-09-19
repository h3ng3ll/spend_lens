import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/models/e_sync_status.dart';
import '../../../../product/domain/models/product/e_unit.dart';
import '../../../../product/domain/normalizer/product_normalizer.dart';
import '../../../../product/domain/repositories/i_product_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/receipt/receipt.dart';
import '../../../domain/models/receipt_item/receipt_item.dart';
import '../../../domain/repositories/i_receipt_item_local_repository.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';
import '../../../domain/use_cases/create_expense_from_receipt_use_case.dart';
import '../../../domain/use_cases/record_price_observations_use_case.dart';
import '../../../../scanner/domain/pending_receipt_draft_store.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../domain/parser/parsed_receipt.dart';
import '../../../domain/rules/receipt_reconciler.dart';
import 'edit_draft_item.dart';

part 'edit_receipt_event.dart';

part 'edit_receipt_state.dart';

part 'edit_receipt_state_ext.dart';

part 'edit_receipt_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built in
/// `EditReceiptPage.initState`, closed in `dispose` — BLoC rule A3.8).
///
/// `load` is a ONE-SHOT read (hive_rules.md §6's explicit exemption: "form/
/// action blocs loading an initial value to populate an editor") — this
/// screen is a form seeded once from the existing [Receipt]/[ReceiptItem]s,
/// never a live display of data another screen might mutate concurrently.
///
/// Every edit here changes `EditDraftItem.name`, never `rawName` — the
/// underlying `ReceiptItem.rawName` is carried forward UNCHANGED into the
/// saved item (spec §11, the hardest invariant this milestone protects).
class EditReceiptBloc extends Bloc<EditReceiptEvent, EditReceiptState> {
  final IReceiptLocalRepository _receiptRepository;
  final IReceiptItemLocalRepository _receiptItemRepository;
  final IProductLocalRepository _productRepository;
  final IStoreLocalRepository _storeRepository;
  final ProductNormalizer _productNormalizer;
  final PendingReceiptDraftStore _draftStore;
  final CreateExpenseFromReceiptUseCase _createExpenseFromReceipt;
  final RecordPriceObservationsUseCase _recordPriceObservations;
  final ReceiptReconciler _reconciler;
  final DateTime Function() _now;

  EditReceiptBloc({
    required this._receiptRepository,
    required this._draftStore,
    required this._receiptItemRepository,
    required this._productRepository,
    required this._storeRepository,
    required this._createExpenseFromReceipt,
    required this._recordPriceObservations,
    this._productNormalizer = const ProductNormalizer(),
    this._reconciler = const ReceiptReconciler(),
    this._now = DateTime.now,
  }) : super(const EditReceiptState()) {
    on<_Load>(_onLoad);
    on<_PickStore>(_onPickStore);
    on<_SetStore>(_onSetStore);
    on<_SetCategory>(_onSetCategory);
    on<_SetPurchasedAt>(_onSetPurchasedAt);
    on<_SetPrintedTotal>(_onSetPrintedTotal);
    on<_UpdateItemName>(_onUpdateItemName);
    on<_UpdateItemQuantity>(_onUpdateItemQuantity);
    on<_CycleItemUnit>(_onCycleItemUnit);
    on<_UpdateItemPrice>(_onUpdateItemPrice);
    on<_RemoveItem>(_onRemoveItem);
    on<_AddItem>(_onAddItem);
    on<_Save>(_onSave);
  }

  Future<void> _onLoad(_Load event, Emitter<EditReceiptState> emit) async {
    emit(state.copyWith(status: EEditReceiptStatus.loading));

    // The UNSAVED path: Review's `Correct` is pure navigation, so there is
    // no persisted receipt to read — the in-progress scan lives on the
    // draft store.
    if (event.receiptId == kPendingDraftReceiptId) {
      await _loadFromPendingDraft(emit);
      return;
    }

    final receipt = await _receiptRepository.getById(event.receiptId);
    if (receipt == null) {
      emit(
        state.copyWith(
          status: EEditReceiptStatus.failed,
          errorMessage: 'receipt_not_found',
        ),
      );
      return;
    }

    final items = <EditDraftItem>[];
    for (final itemId in receipt.itemIds) {
      final item = await _receiptItemRepository.getById(itemId);
      if (item == null || item.deletedAt != null) continue;
      items.add(
        EditDraftItem(
          id: item.id,
          rawName: item.rawName,
          name: item.normalizedName,
          quantity: item.quantity,
          unit: item.unit,
          lineTotal: item.lineTotal,
        ),
      );
    }

    emit(
      state.copyWith(
        status: EEditReceiptStatus.ready,
        receiptId: receipt.id,
        storeId: receipt.storeId,
        // The id alone left the Store row rendering its placeholder on a
        // saved receipt that definitely had one.
        storeName: await _storeNameFor(receipt.storeId),
        categoryId: receipt.categoryId,
        purchasedAt: receipt.purchasedAt,
        printedTotal: receipt.printedTotal,
        items: items,
        matchesTotal: _reconciler
            .reconcile(
              printedTotal: receipt.printedTotal,
              itemsTotal: items.fold(0.0, (s, i) => s + i.lineTotal),
            )
            .matches,
      ),
    );
  }

  /// Loads the in-progress, UNSAVED scan from [PendingReceiptDraftStore].
  ///
  /// `receiptId` is left NULL in the emitted state — that null is what
  /// [_onSave] branches on to write corrections back to the draft instead
  /// of to Hive, so an unsaved receipt stays unsaved.
  Future<void> _loadFromPendingDraft(Emitter<EditReceiptState> emit) async {
    final draft = _draftStore.current;
    if (draft == null) {
      emit(
        state.copyWith(
          status: EEditReceiptStatus.failed,
          errorMessage: 'receipt_not_found',
        ),
      );
      return;
    }

    final parsed = draft.parsedReceipt;
    final items = [
      for (final candidate in parsed.items)
        EditDraftItem(
          id: '${candidate.lineIndex}',
          rawName: candidate.rawName,
          name: candidate.rawName,
          quantity: candidate.quantity,
          unit: candidate.unit,
          lineTotal: candidate.lineTotal,
        ),
    ];

    emit(
      state.copyWith(
        status: EEditReceiptStatus.ready,
        // Seeded so re-entering the editor shows the store already chosen,
        // instead of the "not selected" placeholder over a real pick.
        storeId: parsed.storeId,
        storeName: await _storeNameFor(parsed.storeId),
        isStoreUserPicked: parsed.isStoreUserPicked,
        purchasedAt: parsed.purchasedAt,
        printedTotal: parsed.total,
        items: items,
        matchesTotal: _reconciler
            .reconcile(
              printedTotal: parsed.total,
              itemsTotal: items.fold(0.0, (sum, i) => sum + i.lineTotal),
            )
            .matches,
      ),
    );
  }

  /// Writes the corrections back onto the draft — NOT to Hive.
  ///
  /// "Apply corrections" on an unsaved scan returns to Review with the
  /// edits applied; only Review's Save Receipt persists anything.
  void _applyCorrectionsToDraft(Emitter<EditReceiptState> emit) {
    final existing = _draftStore.current;
    if (existing == null) {
      emit(
        state.copyWith(
          status: EEditReceiptStatus.failed,
          errorMessage: 'save_failed',
        ),
      );
      return;
    }

    _draftStore.updateParsedReceipt(
      ParsedReceipt(
        // `storeName` deliberately keeps the ORIGINAL OCR text (spec §11 —
        // the printed name stays attached for price history). The user's
        // choice rides on `storeId`, which had nowhere to live before:
        // this method rewrote the draft with only the printed name, so
        // picking a store in "Correct receipt" and tapping Done silently
        // discarded it, and the receipt saved with no store at all.
        storeName: existing.parsedReceipt.storeName,
        storeId: state.storeId ?? existing.parsedReceipt.storeId,
        isStoreUserPicked:
            state.isStoreUserPicked ||
            existing.parsedReceipt.isStoreUserPicked,
        purchasedAt: state.purchasedAt ?? existing.parsedReceipt.purchasedAt,
        total: state.printedTotal,
        discount: existing.parsedReceipt.discount,
        items: [
          for (var i = 0; i < state.items.length; i++)
            ParsedLineCandidate(
              // An OCR-derived row keeps its ORIGINAL rawName (spec §11);
              // a manually-added row has none, so its typed name becomes
              // the rawName exactly as the Hive path does.
              rawName: state.items[i].rawName.isEmpty
                  ? state.items[i].name
                  : state.items[i].rawName,
              quantity: state.items[i].quantity,
              unit: state.items[i].unit,
              lineTotal: state.items[i].lineTotal,
              confidence: 1.0,
              lineIndex: i,
            ),
        ],
      ),
    );

    emit(state.copyWith(status: EEditReceiptStatus.saved));
  }

  /// The display name for [storeId], or `''` when there is no store (or it
  /// has since been deleted). `''` is what the UI renders as "not selected".
  Future<String> _storeNameFor(String? storeId) async {
    if (storeId == null) return '';
    final store = await _storeRepository.getById(storeId);
    return store?.name ?? '';
  }

  /// Resolves the picked store id against the repository — used to be a
  /// UI-side `getById` read in `EditReceiptPage._onPickStore`.
  Future<void> _onPickStore(
    _PickStore event,
    Emitter<EditReceiptState> emit,
  ) async {
    final store = await _storeRepository.getById(event.storeId);
    if (store == null) return;
    emit(
      state.copyWith(
        storeId: store.id,
        storeName: store.name,
        // An explicit pick — this is what authorises alias learning later.
        isStoreUserPicked: true,
      ),
    );
  }

  void _onSetStore(_SetStore event, Emitter<EditReceiptState> emit) {
    emit(state.copyWith(storeId: event.storeId, storeName: event.storeName));
  }

  void _onSetCategory(_SetCategory event, Emitter<EditReceiptState> emit) {
    emit(state.copyWith(categoryId: event.categoryId));
  }

  void _onSetPurchasedAt(
    _SetPurchasedAt event,
    Emitter<EditReceiptState> emit,
  ) {
    emit(state.copyWith(purchasedAt: event.purchasedAt));
  }

  void _onSetPrintedTotal(
    _SetPrintedTotal event,
    Emitter<EditReceiptState> emit,
  ) {
    emit(
      state.copyWith(
        printedTotal: event.printedTotal,
        matchesTotal: _reconciler
            .reconcile(
              printedTotal: event.printedTotal,
              itemsTotal: state.itemsTotal,
            )
            .matches,
      ),
    );
  }

  void _onUpdateItemName(
    _UpdateItemName event,
    Emitter<EditReceiptState> emit,
  ) {
    final updated = state.items.map((item) {
      if (item.id != event.itemId) return item;
      // `rawName` untouched — only `name` (spec §11).
      return item.copyWith(name: event.name);
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void _onUpdateItemQuantity(
    _UpdateItemQuantity event,
    Emitter<EditReceiptState> emit,
  ) {
    final updated = state.items.map((item) {
      if (item.id != event.itemId) return item;
      return item.copyWith(quantity: event.quantity);
    }).toList();
    emit(state.copyWith(items: updated));
  }

  /// Advances one item's unit: piece -> kilogram -> liter -> piece.
  ///
  /// A cycle rather than a picker sheet: three values is short enough that
  /// tapping through is faster than opening and dismissing a modal, and it
  /// adds no new screen.
  void _onCycleItemUnit(_CycleItemUnit event, Emitter<EditReceiptState> emit) {
    final updated = state.items.map((item) {
      if (item.id != event.itemId) return item;
      return item.copyWith(
        unit: switch (item.unit) {
          EUnit.piece => EUnit.kilogram,
          EUnit.kilogram => EUnit.liter,
          EUnit.liter => EUnit.piece,
        },
      );
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void _onUpdateItemPrice(
    _UpdateItemPrice event,
    Emitter<EditReceiptState> emit,
  ) {
    final updated = state.items.map((item) {
      if (item.id != event.itemId) return item;
      return item.copyWith(lineTotal: event.lineTotal);
    }).toList();
    final itemsTotal = updated.fold(0.0, (s, i) => s + i.lineTotal);
    emit(
      state.copyWith(
        items: updated,
        matchesTotal: _reconciler
            .reconcile(printedTotal: state.printedTotal, itemsTotal: itemsTotal)
            .matches,
      ),
    );
  }

  void _onRemoveItem(_RemoveItem event, Emitter<EditReceiptState> emit) {
    final updated = state.items.where((i) => i.id != event.itemId).toList();
    emit(state.copyWith(items: updated));
  }

  void _onAddItem(_AddItem event, Emitter<EditReceiptState> emit) {
    final now = _now();
    final newItem = EditDraftItem(
      id: '${now.microsecondsSinceEpoch}_manual',
      rawName: '',
      name: '',
      quantity: 1.0,
      unit: EUnit.piece,
      lineTotal: 0.0,
    );
    emit(state.copyWith(items: [...state.items, newItem]));
  }

  Future<void> _onSave(_Save event, Emitter<EditReceiptState> emit) async {
    final receiptId = state.receiptId;
    // A null receiptId means the UNSAVED draft path — corrections go back
    // onto the draft store, not into Hive. (This used to `return` silently,
    // which would now make Apply-corrections a dead button.)
    if (receiptId == null) {
      _applyCorrectionsToDraft(emit);
      return;
    }

    try {
      final now = _now();
      final existing = await _receiptRepository.getById(receiptId);
      if (existing == null) {
        emit(
          state.copyWith(
            status: EEditReceiptStatus.failed,
            errorMessage: 'receipt_not_found',
          ),
        );
        return;
      }

      final existingProducts = await _productRepository.getAll();
      final mutableProducts = List.of(existingProducts);

      final itemIds = <String>[];
      final savedItems = <ReceiptItem>[];
      for (var i = 0; i < state.items.length; i++) {
        final draftItem = state.items[i];
        final isManuallyAdded = draftItem.rawName.isEmpty;

        final matchResult = _productNormalizer.normalize(
          rawName: draftItem.name,
          existingProducts: mutableProducts,
          generateId: () => '${now.microsecondsSinceEpoch}_product_$i',
          defaultUnit: draftItem.unit,
        );
        if (matchResult.isNewProduct) {
          mutableProducts.add(matchResult.product);
          await _productRepository.save(matchResult.product);
        }

        final item = ReceiptItem(
          id: draftItem.id,
          // A manually-added row has no OCR origin — its rawName is its
          // typed name, set ONCE here at creation. An OCR-derived row keeps
          // its ORIGINAL rawName untouched (spec §11) — never the edited
          // `name`.
          rawName: isManuallyAdded ? draftItem.name : draftItem.rawName,
          normalizedName: matchResult.product.displayName,
          productId: matchResult.product.id,
          quantity: draftItem.quantity,
          unit: draftItem.unit,
          lineTotal: draftItem.lineTotal,
          confidence: isManuallyAdded ? 1.0 : 1.0,
          isManuallyAdded: isManuallyAdded,
          lineIndex: i,
          updatedAt: now,
          syncStatus: ESyncStatus.pendingUpdate,
        );
        await _receiptItemRepository.save(item);
        savedItems.add(item);
        itemIds.add(item.id);
      }

      final updatedReceipt = existing.copyWith(
        storeId: state.storeId,
        // `CreateExpenseFromReceiptUseCase` below mirrors this onto the
        // `Expense`, which is what the record-detail screen's category chip
        // actually reads — so a category changed here follows through to it.
        categoryId: state.categoryId,
        purchasedAt: state.purchasedAt ?? existing.purchasedAt,
        printedTotal: state.printedTotal,
        itemsTotal: state.itemsTotal,
        itemIds: itemIds,
        isReconciled: state.matchesTotal,
        updatedAt: now,
        syncStatus: ESyncStatus.pendingUpdate,
      );
      await _receiptRepository.save(updatedReceipt);

      // Mirror the receipt into the `expenses` box. Home, History and
      // Analytics all watch `expenses` and NONE of them reads `receipts`,
      // so a receipt saved without this is invisible everywhere — the app
      // still shows "No expenses yet" right after a successful save, and a
      // restart does not help because nothing is missing from the boxes
      // actually being watched.
      //
      // This covers BOTH ways a receipt reaches this screen:
      //
      // - MANUAL ENTRY (scan failed → "Enter Manually"): `ScannerBody`
      //   writes a blank `Receipt` so this editor has a record to load, but
      //   nothing ever created its `Expense`. `ReviewBloc` — the OCR-success
      //   path — was the only caller of this use case.
      // - EDITING an already-saved receipt: the mirrored expense existed but
      //   went stale, since amount/date/store changes stopped at the
      //   `Receipt`.
      //
      // Idempotent by construction: the use case writes with
      // `id: receipt.id` and `save` overwrites at that key, so the create
      // and the update are the same call.
      await _createExpenseFromReceipt(
        receipt: updatedReceipt,
        storeId: updatedReceipt.storeId,
      );

      // Re-derive the product<->store edges from the CORRECTED lines. The
      // use case replaces this receipt's previous observations rather than
      // appending, so a renamed or removed line does not leave a superseded
      // row inflating the store's product count.
      await _recordPriceObservations(
        receiptId: updatedReceipt.id,
        storeId: updatedReceipt.storeId,
        items: savedItems,
        observedAt: updatedReceipt.purchasedAt,
        currencyCode: updatedReceipt.currencyCode,
        now: now,
      );

      emit(state.copyWith(status: EEditReceiptStatus.saved));
    } catch (_) {
      emit(
        state.copyWith(
          status: EEditReceiptStatus.failed,
          errorMessage: 'save_failed',
        ),
      );
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../scanner/domain/pending_receipt_draft_store.dart';
import '../../../../store/domain/use_cases/resolve_receipt_store_use_case.dart';
import '../../../domain/parser/parsed_receipt.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';
import '../../../domain/rules/receipt_duplicate_detector.dart';
import '../../../domain/rules/receipt_reconciler.dart';
import '../../../domain/use_cases/save_scanned_receipt_use_case.dart';
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
  final SaveScannedReceiptUseCase _saveScannedReceipt;
  final ResolveReceiptStoreUseCase _resolveReceiptStore;
  final ReceiptReconciler _reconciler;
  final ReceiptDuplicateDetector _duplicateDetector;
  final DateTime Function() _now;

  ReviewBloc({
    required this._draftStore,
    required this._receiptRepository,
    required this._saveScannedReceipt,
    required this._resolveReceiptStore,
    this._reconciler = const ReceiptReconciler(),
    this._duplicateDetector = const ReceiptDuplicateDetector(),
    this._now = DateTime.now,
  }) : super(const ReviewState()) {
    on<_Load>(_onLoad);
    on<_StartEditItem>(_onStartEditItem);
    on<_CommitEditedName>(_onCommitEditedName);
    on<_StopEditItem>(_onStopEditItem);
    on<_SetCategory>(_onSetCategory);
    on<_SetPurchasedAt>(_onSetPurchasedAt);
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
            // A corrected name on the candidate is a rename the user made
            // in "Correct receipt"; falling back to `rawName` unconditionally
            // is what used to throw that correction away on the way back.
            name: candidate.name ?? candidate.rawName,
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

    // A store already on the draft wins: it is either a pick the user made
    // in "Correct receipt" or a match resolved on a previous pass, and
    // re-matching would silently overrule the person who chose it.
    final storeId =
        parsed.storeId ?? (await _resolveReceiptStore(parsed.storeName))?.id;

    final existingReceipts = await _receiptRepository.getAll();
    final likelyDuplicate = _duplicateDetector.findLikelyDuplicate(
      // Was hardcoded `null`, which made the duplicate check store-blind:
      // two different shops on the same day for the same total looked like
      // the same receipt.
      storeId: storeId,
      purchasedAt: parsed.purchasedAt ?? _now(),
      total: parsed.total ?? itemsTotal,
      existingReceipts: existingReceipts,
    );

    emit(
      state.copyWith(
        status: EReviewStatus.ready,
        storeName: parsed.storeName,
        storeId: storeId,
        isStoreUserPicked: parsed.isStoreUserPicked,
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

  void _onSetPurchasedAt(_SetPurchasedAt event, Emitter<ReviewState> emit) {
    emit(state.copyWith(purchasedAt: event.purchasedAt));
  }

  Future<void> _onSave(_Save event, Emitter<ReviewState> emit) async {
    final receiptId = await _persist();
    emit(
      state.copyWith(status: EReviewStatus.saved, savedReceiptId: receiptId),
    );
  }

  /// `Correct` NAVIGATES — it does not save.
  ///
  /// This previously ran the full [_persist], committing the receipt, its
  /// items, its products AND its expense before the user had seen a Save
  /// button, let alone tapped one. The design is explicit that the
  /// Correct → Edit → Apply-corrections loop is pure navigation
  /// (`goEdit`/`goReview` are `setState` screen switches) and that
  /// `saveReceipt` is the ONLY writer.
  ///
  /// The current in-progress edits are pushed back onto the draft store so
  /// the Edit screen loads what the user is actually looking at — including
  /// any item renames made here — rather than re-reading the original parse.
  void _onSaveAndCorrect(_SaveAndCorrect event, Emitter<ReviewState> emit) {
    _draftStore.updateParsedReceipt(
      ParsedReceipt(
        storeName: state.storeName,
        // Without these two the store resolved (or picked) here would be
        // lost the moment the user tapped Correct.
        storeId: state.storeId,
        isStoreUserPicked: state.isStoreUserPicked,
        purchasedAt: state.purchasedAt,
        total: state.printedTotal,
        items: [
          for (var i = 0; i < state.items.length; i++)
            ParsedLineCandidate(
              // `rawName` is preserved byte-for-byte (spec §11) — only
              // `name` is user-editable, and it is carried separately so
              // the Edit screen shows the edited text.
              rawName: state.items[i].rawName,
              name: state.items[i].name,
              quantity: state.items[i].quantity,
              unit: state.items[i].unit,
              unitPrice: state.items[i].unitPrice,
              lineTotal: state.items[i].lineTotal,
              confidence: state.items[i].confidence,
              lineIndex: i,
            ),
        ],
      ),
    );

    emit(state.copyWith(status: EReviewStatus.correcting));
  }

  /// Shared persistence path for both [_onSave] and [_onSaveAndCorrect] —
  /// the two differ ONLY in which status/navigation follows, never in what
  /// gets written.
  ///
  /// The writing itself lives in [SaveScannedReceiptUseCase]: it is domain
  /// policy (normalization, the `rawName` invariant, the mirroring expense,
  /// alias learning), not screen behaviour, and inlining it here put ~120
  /// lines of persistence rules in a presentation class no test could reach
  /// without building a bloc.
  Future<String> _persist() {
    return _saveScannedReceipt(
      ScannedReceiptInput(
        items: [
          for (final item in state.items)
            ScannedReceiptItemInput(
              id: item.id,
              rawName: item.rawName,
              name: item.name,
              quantity: item.quantity,
              unit: item.unit,
              unitPrice: item.unitPrice,
              lineTotal: item.lineTotal,
              confidence: item.confidence,
              isLowConfidence: item.isLowConfidence,
              isManuallyAdded: item.isManuallyAdded,
            ),
        ],
        storeId: state.storeId,
        storeName: state.storeName,
        isStoreUserPicked: state.isStoreUserPicked,
        categoryId: state.categoryId,
        purchasedAt: state.purchasedAt,
        printedTotal: state.printedTotal,
        itemsTotal: state.itemsTotal,
        isReconciled: state.isReconciled,
        imageFilename: state.imageFilename,
      ),
    );
  }
}

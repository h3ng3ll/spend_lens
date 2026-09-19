part of 'review_bloc.dart';

/// `correcting` is a DISTINCT status from `saved` — the
/// Review screen's two exit paths (Save Receipt -> Home, Correct -> Edit
/// receipt) must not share one status, or a single `BlocListener` branch
/// would fire the wrong navigation for one of them
/// (`handler-pops-and-listener-pops-destructive-confirm-pops-twice`'s
/// lesson: give a non-exiting/differently-routed action its own status).
enum EReviewStatus { initial, loading, ready, saved, correcting, failed }

/// `imageFilename` holds the capture's FILENAME on disk, never its bytes.
/// A `Uint8List` field here made every `copyWith` run
/// `DeepCollectionEquality` over a multi-megabyte JPEG for `==`/`hashCode`,
/// and `toString()` interpolate it byte by byte — on a state that re-emits
/// on every keystroke. See `PendingReceiptDraft.imageFilename`.
@freezed
sealed class ReviewState with _$ReviewState {
  const factory ReviewState({
    @Default(EReviewStatus.initial) EReviewStatus status,

    /// The store name as PRINTED on the receipt — raw OCR text, displayed on
    /// the store card and kept for price history (spec §11).
    String? storeName,

    /// The resolved store this receipt belongs to, or null when nothing
    /// matched. Written into `Receipt.storeId` AND `Expense.storeId` on
    /// save; before this field existed both were always null, so a scanned
    /// receipt never appeared under any store.
    String? storeId,

    /// Whether [storeId] was chosen by the user rather than auto-matched.
    /// Gates alias learning — see `LearnStoreAliasUseCase`.
    @Default(false) bool isStoreUserPicked,
    DateTime? purchasedAt,
    double? printedTotal,
    @Default(<ReviewDraftItem>[]) List<ReviewDraftItem> items,
    String? categoryId,
    String? editingItemId,
    @Default(false) bool isReconciled,
    double? reconciliationDifference,
    @Default(false) bool isLikelyDuplicate,
    String? imageFilename,
    String? savedReceiptId,
    String? errorMessage,
  }) = _ReviewState;
}

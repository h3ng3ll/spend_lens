part of 'review_bloc.dart';

/// `savedThenCorrect` is a DISTINCT terminal status from `saved` — the
/// Review screen's two exit paths (Save Receipt -> Home, Correct -> Edit
/// receipt) must not share one status, or a single `BlocListener` branch
/// would fire the wrong navigation for one of them
/// (`handler-pops-and-listener-pops-destructive-confirm-pops-twice`'s
/// lesson: give a non-exiting/differently-routed action its own status).
enum EReviewStatus { initial, loading, ready, saved, savedThenCorrect, failed }

@freezed
sealed class ReviewState with _$ReviewState {
  const factory ReviewState({
    @Default(EReviewStatus.initial) EReviewStatus status,
    String? storeName,
    DateTime? purchasedAt,
    double? printedTotal,
    @Default(<ReviewDraftItem>[]) List<ReviewDraftItem> items,
    String? categoryId,
    String? editingItemId,
    @Default(false) bool isReconciled,
    double? reconciliationDifference,
    @Default(false) bool isLikelyDuplicate,
    Uint8List? imageBytes,
    String? savedReceiptId,
    String? errorMessage,
  }) = _ReviewState;
}

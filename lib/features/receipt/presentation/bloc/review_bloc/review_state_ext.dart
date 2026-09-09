part of 'review_bloc.dart';

extension ReviewStateX on ReviewState {
  bool get isLoading => status == EReviewStatus.loading;

  bool get isReady => status == EReviewStatus.ready;

  bool get isSaved => status == EReviewStatus.saved;

  bool get isCorrecting => status == EReviewStatus.correcting;

  /// Whether the review CONTENT should render.
  ///
  /// `correcting` is a transient navigation trigger, not a loading state —
  /// the parsed receipt is fully in hand. Treating it as "not ready" left a
  /// permanent `CircularProgressIndicator` on Review once the user popped
  /// back from the Edit screen.
  bool get hasContent => isReady || isSaved || isCorrecting;

  bool get isFailed => status == EReviewStatus.failed;

  double get itemsTotal =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);
}

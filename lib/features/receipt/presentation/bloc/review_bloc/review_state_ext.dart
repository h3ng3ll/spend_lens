part of 'review_bloc.dart';

extension ReviewStateX on ReviewState {
  bool get isLoading => status == EReviewStatus.loading;

  bool get isReady => status == EReviewStatus.ready;

  bool get isSaved => status == EReviewStatus.saved;

  bool get isSavedThenCorrect => status == EReviewStatus.savedThenCorrect;

  bool get isFailed => status == EReviewStatus.failed;

  double get itemsTotal =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);
}

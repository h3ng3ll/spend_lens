part of 'price_history_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension PriceHistoryStateX on PriceHistoryState {
  bool get isInitial => status == EPriceHistoryStatus.initial;

  bool get isLoading => status == EPriceHistoryStatus.loading;

  bool get isReady => status == EPriceHistoryStatus.ready;

  /// The product exists but has no [PriceObservation]s yet — an EMPTY
  /// state, never `failed` (chronic bug
  /// `absent-data-mapped-to-failed-status-first-launch-shows-something-
  /// went-wrong`: absent data is not an error).
  bool get isEmpty => status == EPriceHistoryStatus.empty;

  /// The product record itself no longer exists (e.g. deleted elsewhere
  /// while this screen was open) — distinct from [isEmpty] and [isFailed].
  bool get isNotFound => status == EPriceHistoryStatus.notFound;

  bool get isFailed => status == EPriceHistoryStatus.failed;
}

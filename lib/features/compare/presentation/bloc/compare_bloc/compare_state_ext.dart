part of 'compare_bloc.dart';

extension CompareStateExt on CompareState {
  bool get isInitial => status == ECompareStatus.initial;

  bool get isLoading => status == ECompareStatus.loading;

  bool get isReady => status == ECompareStatus.ready;

  bool get isFailed => status == ECompareStatus.failed;

  /// Fewer than two stores exist, so there is nothing to compare against.
  ///
  /// An ordinary `ready` state with an honest empty screen — NEVER `failed`
  /// (recorded chronic bug
  /// `absent-data-mapped-to-failed-status-first-launch-shows-something-went-wrong`:
  /// absent data is not an error).
  bool get hasTooFewStores => (snapshot?.stores.length ?? 0) < 2;
}

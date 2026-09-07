part of 'history_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension HistoryStateX on HistoryState {
  bool get isInitial => status == EHistoryStatus.initial;

  bool get isLoading => status == EHistoryStatus.loading;

  bool get isLoaded => status == EHistoryStatus.loaded;

  bool get isFailed => status == EHistoryStatus.failed;
}

part of 'stores_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension StoresStateX on StoresState {
  bool get isInitial => status == EStoresStatus.initial;

  bool get isLoading => status == EStoresStatus.loading;

  bool get isReady => status == EStoresStatus.loaded;

  bool get isFailed => status == EStoresStatus.failed;

  /// The most recent quickCreate/create/delete write failed. A one-shot
  /// signal for a `BlocListener` error toast.
  bool get isWriteFailed => lastWriteFailed;
}

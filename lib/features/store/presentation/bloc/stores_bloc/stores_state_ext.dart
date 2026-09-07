part of 'stores_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension StoresStateX on StoresState {
  bool get isInitial => status == EStoresStatus.initial;

  bool get isLoading => status == EStoresStatus.loading;

  bool get isLoaded => status == EStoresStatus.loaded;

  bool get isFailed => status == EStoresStatus.failed;
}

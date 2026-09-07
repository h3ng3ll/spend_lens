part of 'store_page_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension StorePageStateX on StorePageState {
  bool get isInitial => status == EStorePageStatus.initial;

  bool get isLoading => status == EStorePageStatus.loading;

  bool get isReady => status == EStorePageStatus.ready;

  bool get isFailed => status == EStorePageStatus.failed;
}

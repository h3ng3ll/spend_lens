part of 'store_detail_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension StoreDetailStateX on StoreDetailState {
  bool get isInitial => status == EStoreDetailStatus.initial;

  bool get isLoading => status == EStoreDetailStatus.loading;

  bool get isReady => status == EStoreDetailStatus.ready;

  /// The store was deleted (e.g. by this same screen's own delete action, or
  /// from elsewhere) while this screen was still mounted. Treated distinctly
  /// from [isFailed] — no error occurred, the record is simply gone.
  bool get isNotFound => status == EStoreDetailStatus.notFound;

  bool get isFailed => status == EStoreDetailStatus.failed;
}

part of 'store_detail_bloc.dart';

@freezed
sealed class StoreDetailEvent with _$StoreDetailEvent {
  /// Subscribes to the combined store+expenses snapshot for `storeId`.
  /// Dispatched once from `StoreDetailPage.initState` (BLoC rule A3.8 —
  /// never `main()`, since this bloc is screen-scoped, not app-lifetime).
  const factory StoreDetailEvent.watch() = _Watch;
}

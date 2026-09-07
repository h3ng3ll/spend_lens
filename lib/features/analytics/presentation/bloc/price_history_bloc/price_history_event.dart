part of 'price_history_bloc.dart';

@freezed
sealed class PriceHistoryEvent with _$PriceHistoryEvent {
  /// Subscribes to the combined product+observations+stores snapshot.
  /// Dispatched once from `PriceHistoryPage.initState` (BLoC rule A3.8 —
  /// never `main()`, since this bloc is screen-scoped, not app-lifetime).
  const factory PriceHistoryEvent.watch() = _Watch;
}

part of 'store_page_bloc.dart';

@freezed
sealed class StorePageEvent with _$StorePageEvent {
  /// Subscribes to the combined stores+expenses snapshot. Dispatched once
  /// from `StorePage.initState` (BLoC rule A3.8 — never `main()`, since this
  /// bloc is screen-scoped, not app-lifetime).
  const factory StorePageEvent.watch() = _Watch;
}

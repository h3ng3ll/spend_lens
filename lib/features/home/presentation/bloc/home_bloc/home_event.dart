part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  /// Subscribes to the combined expenses+categories snapshot. Dispatched
  /// once from `HomePage.initState` (BLoC rule A3.8 — never `main()`, since
  /// this bloc is screen-scoped, not app-lifetime).
  const factory HomeEvent.watch() = _Watch;
}

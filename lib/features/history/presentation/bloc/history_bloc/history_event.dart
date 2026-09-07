part of 'history_bloc.dart';

@freezed
sealed class HistoryEvent with _$HistoryEvent {
  /// Subscribes to the live expense list. Dispatched once from
  /// `HistoryPage.initState` (BLoC rule A3.8 — never `main()`, since this
  /// bloc is screen-scoped, not app-lifetime).
  const factory HistoryEvent.watch() = _Watch;
}

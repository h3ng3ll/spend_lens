part of 'analytics_bloc.dart';

@freezed
sealed class AnalyticsEvent with _$AnalyticsEvent {
  /// Subscribes to the live expense list. Dispatched once from
  /// `AnalyticsPage.initState` (BLoC rule A3.8 — never `main()`, since this
  /// bloc is screen-scoped, not app-lifetime).
  const factory AnalyticsEvent.watch() = _Watch;
}

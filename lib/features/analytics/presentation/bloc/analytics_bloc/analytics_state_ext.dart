part of 'analytics_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension AnalyticsStateX on AnalyticsState {
  bool get isInitial => status == EAnalyticsStatus.initial;

  bool get isLoading => status == EAnalyticsStatus.loading;

  bool get isLoaded => status == EAnalyticsStatus.loaded;

  bool get isFailed => status == EAnalyticsStatus.failed;

  /// A genuinely empty repository (no expenses recorded yet at all) is its
  /// OWN state — never conflated with [isFailed] (recorded global bug:
  /// absent data mapped to `failed` strands first-launch users on a
  /// permanent, self-reinforcing error screen). `watchAll()` emitting an
  /// empty list is a normal, successful read, not a failure.
  bool get isEmpty => isLoaded && (snapshot?.expenses.isEmpty ?? true);
}

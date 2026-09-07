part of 'analytics_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension AnalyticsStateX on AnalyticsState {
  bool get isInitial => status == EAnalyticsStatus.initial;

  bool get isLoading => status == EAnalyticsStatus.loading;

  bool get isLoaded => status == EAnalyticsStatus.loaded;

  bool get isFailed => status == EAnalyticsStatus.failed;
}

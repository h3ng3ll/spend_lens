part of 'analytics_bloc.dart';

enum EAnalyticsStatus { initial, loading, loaded, failed }

@freezed
sealed class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState({
    @Default(EAnalyticsStatus.initial) EAnalyticsStatus status,
    AnalyticsSnapshot? snapshot,
    @Default('') String errorMessage,
  }) = _AnalyticsState;
}

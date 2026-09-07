part of 'settings_bloc.dart';

enum ESettingsStatus { initial, loading, ready, failed }

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    required ESettingsStatus status,
    required AppSettings settings,
    @Default('') String errorMessage,
  }) = _SettingsState;
}

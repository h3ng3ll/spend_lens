part of 'settings_bloc.dart';

enum ESettingsStatus { initial, loading, ready, failed }

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    required ESettingsStatus status,
    required AppSettings settings,
    @Default('') String errorMessage,

    /// The current expenses+stores+categories count, for the delete-all
    /// confirm dialog's `{n}` copy. `null` until `loadRecordCount` resolves.
    int? recordCount,

    /// Whether the most recent `deleteAll` write failed. A one-shot signal
    /// for an error-toast listener — never read to derive displayed state.
    @Default(false) bool lastDeleteAllFailed,
  }) = _SettingsState;
}

part of 'settings_bloc.dart';

enum ESettingsStatus { initial, loading, ready, failed }

/// Lifecycle of the most recent "Delete all data" run. `running` is emitted
/// before every run, so each completion is a fresh transition for the
/// outcome listeners — a plain success flag stays `true` after the first
/// run and a second delete would report nothing.
enum EDeleteAllStatus { idle, running, done, failed }

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    required ESettingsStatus status,
    required AppSettings settings,
    @Default('') String errorMessage,

    /// The current expenses+stores+categories count, for the delete-all
    /// confirm dialog's `{n}` copy. `null` until `loadRecordCount` resolves.
    int? recordCount,

    /// Outcome of the most recent `deleteAll` run, for the toast listeners.
    @Default(EDeleteAllStatus.idle) EDeleteAllStatus deleteAllStatus,
  }) = _SettingsState;
}

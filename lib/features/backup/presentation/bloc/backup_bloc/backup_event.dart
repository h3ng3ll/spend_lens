part of 'backup_bloc.dart';

/// Intent events (BLoC rule A3.7) — the UI dispatches these and never
/// branches on state to choose between them; the bloc does the real work
/// (design_spendlens.md §6/§9 — export/import must not be inline UI-layer
/// logic).
@freezed
sealed class BackupEvent with _$BackupEvent {
  const factory BackupEvent.exportBackup() = _ExportBackup;

  const factory BackupEvent.exportCsv() = _ExportCsv;

  /// The user picked a file via the OS file picker; [path] is `null` when
  /// they canceled. Reading the picker itself stays a UI-layer concern (it
  /// is a system dialog, not app business logic) — this event carries only
  /// the RESULT into the bloc for validation.
  const factory BackupEvent.importFilePicked(String? path) =
      _ImportFilePicked;

  /// Dispatched after the user confirms the destructive-looking restore in
  /// the shared [ConfirmDialog] — applies the already-validated pending
  /// bundle.
  const factory BackupEvent.confirmImport() = _ConfirmImport;
}

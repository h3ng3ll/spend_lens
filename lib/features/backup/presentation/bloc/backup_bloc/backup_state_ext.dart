part of 'backup_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension BackupStateX on BackupState {
  bool get isIdle => status == EBackupStatus.idle;

  bool get isExportingJson => status == EBackupStatus.exportingJson;

  bool get isExportedJson => status == EBackupStatus.exportedJson;

  bool get isExportingCsv => status == EBackupStatus.exportingCsv;

  bool get isExportedCsv => status == EBackupStatus.exportedCsv;

  bool get isValidatingImport => status == EBackupStatus.validatingImport;

  bool get isImportReady => status == EBackupStatus.importReady;

  bool get isImporting => status == EBackupStatus.importing;

  bool get isImported => status == EBackupStatus.imported;

  bool get isFailed => status == EBackupStatus.failed;

  /// True for every in-progress phase — the minimum `isLoading` contract
  /// (A3 rule 9) mapped onto this bloc's multi-phase status enum, which has
  /// no single generic "loading" value of its own.
  bool get isLoading =>
      status == EBackupStatus.exportingJson ||
      status == EBackupStatus.exportingCsv ||
      status == EBackupStatus.validatingImport ||
      status == EBackupStatus.importing;

  /// True once a phase has reached a stable, non-error terminal outcome —
  /// the minimum `isReady`/`isSuccess` contract (A3 rule 9).
  bool get isReady =>
      status == EBackupStatus.idle ||
      status == EBackupStatus.exportedJson ||
      status == EBackupStatus.exportedCsv ||
      status == EBackupStatus.importReady ||
      status == EBackupStatus.imported;
}

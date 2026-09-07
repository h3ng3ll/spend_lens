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
}

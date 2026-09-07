part of 'backup_bloc.dart';

enum EBackupStatus {
  idle,
  exportingJson,
  exportedJson,
  exportingCsv,
  exportedCsv,
  validatingImport,

  /// A file passed schema validation and is awaiting the user's confirm.
  importReady,
  importing,
  imported,
  failed,
}

/// Classifies WHY [EBackupStatus.failed] happened, so the UI can pick the
/// right copy without string-matching an exception's `toString()`.
enum EBackupError {
  none,
  schemaTooNew,
  malformed,
  unexpected,
}

@freezed
sealed class BackupState with _$BackupState {
  const factory BackupState({
    @Default(EBackupStatus.idle) EBackupStatus status,
    @Default(EBackupError.none) EBackupError error,
    @Default('') String errorMessage,

    /// Populated once [EBackupStatus.exportedJson] /
    /// [EBackupStatus.exportedCsv] — the file the UI hands to the share
    /// sheet, and the label the toast needs.
    File? exportedFile,
    @Default('') String exportedFilename,
    @Default(0) int exportedRowCount,

    /// Populated once [EBackupStatus.importReady] — already validated by
    /// [BackupJsonCodec.decode]; [BackupEvent.confirmImport] applies it.
    BackupBundle? pendingImport,

    /// Populated once [EBackupStatus.imported] — the counts the success
    /// toast reports.
    @Default(0) int importedReceiptCount,
    @Default(0) int importedExpenseCount,
  }) = _BackupState;
}

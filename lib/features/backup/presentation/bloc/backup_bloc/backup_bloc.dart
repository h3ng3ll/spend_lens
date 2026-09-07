import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/backup_json_codec.dart';
import '../../../domain/models/backup_bundle/backup_bundle.dart';
import '../../../domain/use_cases/export_backup_use_case.dart';
import '../../../domain/use_cases/export_csv_use_case.dart';
import '../../../domain/use_cases/import_backup_use_case.dart';

part 'backup_event.dart';

part 'backup_state.dart';

part 'backup_state_ext.dart';

part 'backup_bloc.freezed.dart';

/// Screen-scoped bloc (BLoC rule A3.8) — built in `ProfilePage.initState`,
/// closed on dispose; never dispatched from `main()`.
///
/// Owns every business step of export/import (design_spendlens.md §6/§9):
/// building the JSON/CSV file, and validating + applying a restored backup.
/// The UI layer's only responsibilities are launching the OS file picker
/// (a system dialog, not app logic) and the OS share sheet — the actual
/// read/write/validate work happens here, never inline in a widget
/// callback.
class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final ExportBackupUseCase _exportBackupUseCase;
  final ExportCsvUseCase _exportCsvUseCase;
  final ImportBackupUseCase _importBackupUseCase;

  BackupBloc({
    required ExportBackupUseCase exportBackupUseCase,
    required ExportCsvUseCase exportCsvUseCase,
    required ImportBackupUseCase importBackupUseCase,
  }) : this._(exportBackupUseCase, exportCsvUseCase, importBackupUseCase);

  BackupBloc._(
    this._exportBackupUseCase,
    this._exportCsvUseCase,
    this._importBackupUseCase,
  ) : super(const BackupState()) {
    on<BackupEvent>(
      (event, emit) => switch (event) {
        _ExportBackup() => _onExportBackup(emit),
        _ExportCsv() => _onExportCsv(emit),
        _ImportFilePicked(:final path) => _onImportFilePicked(path, emit),
        _ConfirmImport() => _onConfirmImport(emit),
      },
      // One export/import action at a time — a double-tap must not race
      // two file writes or two Hive-import passes concurrently.
      transformer: sequential(),
    );
  }

  Future<void> _onExportBackup(Emitter<BackupState> emit) async {
    emit(state.copyWith(status: EBackupStatus.exportingJson));
    try {
      final result = await _exportBackupUseCase.call();
      emit(
        state.copyWith(
          status: EBackupStatus.exportedJson,
          exportedFile: result.file,
          exportedFilename: result.filename,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EBackupStatus.failed,
          error: EBackupError.unexpected,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onExportCsv(Emitter<BackupState> emit) async {
    emit(state.copyWith(status: EBackupStatus.exportingCsv));
    try {
      final result = await _exportCsvUseCase.call();
      emit(
        state.copyWith(
          status: EBackupStatus.exportedCsv,
          exportedFile: result.file,
          exportedFilename: result.filename,
          exportedRowCount: result.rowCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EBackupStatus.failed,
          error: EBackupError.unexpected,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// `path == null` means the user canceled the OS file picker — that is
  /// not a failure, so it returns to [EBackupStatus.idle] rather than
  /// [EBackupStatus.failed].
  Future<void> _onImportFilePicked(
    String? path,
    Emitter<BackupState> emit,
  ) async {
    if (path == null) {
      emit(state.copyWith(status: EBackupStatus.idle));
      return;
    }

    emit(state.copyWith(status: EBackupStatus.validatingImport));

    try {
      final raw = await File(path).readAsString();
      final bundle = BackupJsonCodec.decode(raw);
      emit(
        state.copyWith(
          status: EBackupStatus.importReady,
          pendingImport: bundle,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EBackupStatus.failed,
          error: _classifyError(e),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onConfirmImport(Emitter<BackupState> emit) async {
    final pending = state.pendingImport;
    if (pending == null) return;

    emit(state.copyWith(status: EBackupStatus.importing));

    try {
      final result = await _importBackupUseCase.applyBundle(pending);
      emit(
        state.copyWith(
          status: EBackupStatus.imported,
          importedReceiptCount: result.receiptCount,
          importedExpenseCount: result.expenseCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EBackupStatus.failed,
          error: EBackupError.unexpected,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Maps the two [BackupJsonCodec.decode] exception types to their own
  /// [EBackupError] value, so the UI never string-matches an exception's
  /// `toString()` to choose copy.
  EBackupError _classifyError(Object error) => switch (error) {
    BackupSchemaTooNewException() => EBackupError.schemaTooNew,
    BackupMalformedException() => EBackupError.malformed,
    _ => EBackupError.unexpected,
  };
}

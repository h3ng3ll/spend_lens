import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/models/app_settings/app_settings.dart';
import '../../../domain/models/app_settings/e_app_theme_mode.dart';
import '../../../domain/models/app_settings/e_flash_mode.dart';
import '../../../domain/use_cases/delete_all_records_use_case.dart';
import '../../../domain/use_cases/save_settings_use_case.dart';
import '../../../domain/use_cases/watch_settings_use_case.dart';

part 'settings_event.dart';

part 'settings_state.dart';

part 'settings_state_ext.dart';

part 'settings_bloc.freezed.dart';

/// App-lifetime settings bloc (design_spendlens.md §5: `registerLazySingleton`,
/// dispatched once from `main()` — never re-dispatched from a screen's
/// `initState`, per BLoC rule A3.8).
///
/// Recorded global bug `splash-first-frame-default-theme-async-settings`:
/// the persisted theme/locale MUST be resolved SYNCHRONOUSLY before
/// `runApp` and used to SEED this bloc's initial state — never left to
/// arrive only via an awaited `fetch()`/`watch()`, or the first frame paints
/// with the wrong theme and/or the wrong language before snapping correct.
/// `main()` therefore calls `GetSettingsUseCase` and awaits it BEFORE
/// `runApp`, then passes the result in as [initialSettings] here. The
/// `SettingsEvent.watch()` dispatched afterward is an idempotent reconcile
/// that keeps the bloc live for later writes — not the FIRST source of
/// truth for the first frame.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final WatchSettingsUseCase _watchSettingsUseCase;
  final SaveSettingsUseCase _saveSettingsUseCase;
  final DeleteAllRecordsUseCase _deleteAllRecordsUseCase;
  final IExpenseLocalRepository _expenseLocalRepository;
  final IStoreLocalRepository _storeLocalRepository;
  final ICategoryLocalRepository _categoryLocalRepository;

  SettingsBloc({
    required AppSettings initialSettings,
    required this._watchSettingsUseCase,
    required this._saveSettingsUseCase,
    required this._deleteAllRecordsUseCase,
    required this._expenseLocalRepository,
    required this._storeLocalRepository,
    required this._categoryLocalRepository,
  }) : super(
         SettingsState(
           status: ESettingsStatus.ready,
           settings: initialSettings,
         ),
       ) {
    on<_Watch>(_onWatch);
    on<_SetLocale>(_onSetLocale);
    on<_SetCurrency>(_onSetCurrency);
    on<_PickTheme>(_onPickTheme);
    on<_CompleteOnboarding>(_onCompleteOnboarding);
    on<_ToggleFlashMode>(_onToggleFlashMode);
    on<_LoadRecordCount>(_onLoadRecordCount);
    on<_DeleteAll>(_onDeleteAll);
  }

  Future<void> _onWatch(_Watch event, Emitter<SettingsState> emit) async {
    await emit.forEach<AppSettings>(
      _watchSettingsUseCase(),
      onData: (settings) =>
          state.copyWith(status: ESettingsStatus.ready, settings: settings),
      onError: (error, stackTrace) => state.copyWith(
        status: ESettingsStatus.failed,
        errorMessage: error.toString(),
      ),
    );
  }

  Future<void> _onSetLocale(
    _SetLocale event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(localeCode: event.code);
    if (updated == state.settings) return;

    emit(state.copyWith(settings: updated));
    await _saveSettingsUseCase(updated);
  }

  Future<void> _onSetCurrency(
    _SetCurrency event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(currencyCode: event.code);
    if (updated == state.settings) return;

    emit(state.copyWith(settings: updated));
    await _saveSettingsUseCase(updated);
  }

  Future<void> _onPickTheme(
    _PickTheme event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(themeMode: event.mode);
    if (updated == state.settings) return;

    emit(state.copyWith(settings: updated));
    await _saveSettingsUseCase(updated);
  }

  Future<void> _onCompleteOnboarding(
    _CompleteOnboarding event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.settings.onboardingCompleted) return;

    final updated = state.settings.copyWith(onboardingCompleted: true);
    emit(state.copyWith(settings: updated));
    await _saveSettingsUseCase(updated);
  }

  Future<void> _onToggleFlashMode(
    _ToggleFlashMode event,
    Emitter<SettingsState> emit,
  ) async {
    final next = switch (state.settings.flashMode) {
      EFlashMode.auto => EFlashMode.on,
      EFlashMode.on => EFlashMode.off,
      EFlashMode.off => EFlashMode.auto,
    };
    final updated = state.settings.copyWith(flashMode: next);

    emit(state.copyWith(settings: updated));
    await _saveSettingsUseCase(updated);
  }

  /// Sums the current record count across the datasets
  /// [DeleteAllRecordsUseCase] clears, for the delete-all confirm dialog's
  /// `{n}` — a one-shot read feeding a dialog's copy, not reactively
  /// displayed state, so `getAll()` here is not a hive_rules.md §9
  /// violation (that rule governs reactive screen state). Used to be a
  /// UI-side method in `SettingsPage` calling three repositories directly
  /// via `getIt`.
  Future<void> _onLoadRecordCount(
    _LoadRecordCount event,
    Emitter<SettingsState> emit,
  ) async {
    // Cleared first so the page's `firstWhere(recordCount != null)` always
    // sees a NEW state. Re-emitting an unchanged count is deduplicated by
    // Bloc, which left that wait — and the tap behind it — hanging forever
    // on every press after the first, then released them all at once on the
    // next unrelated settings change.
    emit(state.copyWith(recordCount: null));
    final expenses = await _expenseLocalRepository.getAll();
    final stores = await _storeLocalRepository.getAll();
    final categories = await _categoryLocalRepository.getAll();
    emit(
      state.copyWith(
        recordCount: expenses.length + stores.length + categories.length,
      ),
    );
  }

  /// The destructive delete-all write (delete_all_records_rules.md): the
  /// confirm dialog has already run by the time this is dispatched. Used to
  /// be a UI-side `getIt<DeleteAllRecordsUseCase>().call()` fire-and-forget
  /// call from `SettingsPage._onConfirmDeleteAll`, whose success toast fired
  /// from a `.then(...)` chained at the dispatch site rather than from an
  /// outcome listener, and whose failure was never surfaced at all.
  Future<void> _onDeleteAll(
    _DeleteAll event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.isDeleteAllRunning) return;

    emit(state.copyWith(deleteAllStatus: EDeleteAllStatus.running));
    try {
      await _deleteAllRecordsUseCase.call(uid: event.uid);
      emit(state.copyWith(deleteAllStatus: EDeleteAllStatus.done));
    } catch (_) {
      emit(state.copyWith(deleteAllStatus: EDeleteAllStatus.failed));
    }
  }
}

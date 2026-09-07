import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/app_settings/app_settings.dart';
import '../../../domain/models/app_settings/e_app_theme_mode.dart';
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

  SettingsBloc({
    required AppSettings initialSettings,
    required this._watchSettingsUseCase,
    required this._saveSettingsUseCase,
  }) : super(
          SettingsState(
            status: ESettingsStatus.ready,
            settings: initialSettings,
          ),
        ) {
    on<_Watch>(_onWatch);
    on<_SetLocale>(_onSetLocale);
    on<_SetCurrency>(_onSetCurrency);
    on<_ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onWatch(
    _Watch event,
    Emitter<SettingsState> emit,
  ) async {
    await emit.forEach<AppSettings>(
      _watchSettingsUseCase(),
      onData: (settings) => state.copyWith(
        status: ESettingsStatus.ready,
        settings: settings,
      ),
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

  Future<void> _onToggleTheme(
    _ToggleTheme event,
    Emitter<SettingsState> emit,
  ) async {
    final next = state.settings.themeMode == EAppThemeMode.dark
        ? EAppThemeMode.light
        : EAppThemeMode.dark;
    final updated = state.settings.copyWith(themeMode: next);

    emit(state.copyWith(settings: updated));
    await _saveSettingsUseCase(updated);
  }
}

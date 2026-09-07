import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The app-wide `Bloc.observer` (registered once in `main()`).
///
/// Logs bloc lifecycle by TYPE NAME only — never by interpolating a bloc's
/// `event`/`state`/`change`/`transition` object into the log line. Several
/// states in this app carry genuine PII (`AuthState.email`, the signed-in
/// user's address — `features/auth/presentation/bloc/auth_bloc/auth_state.dart`),
/// and freezed's generated `toString()` prints every field, so
/// `'...: $state'` would have written the user's email to the device log on
/// every single state change, in every build (debug AND release). Logging
/// `state.runtimeType` instead is structurally immune to this: a new field
/// added to any future state/event can never leak through a call site that
/// never reads the object's own `toString()`.
///
/// Also gated on [kDebugMode] — a release build should not be writing
/// per-transition logs to the device log at all.
class AppObserver extends BlocObserver {
  static AppObserver? _singleton;

  AppObserver._();

  factory AppObserver.instance() => _singleton ??= AppObserver._();

  void _log(String message) {
    if (!kDebugMode) return;
    log(message, name: 'Bloc');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _log('[Create] ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _log('[Event] in ${bloc.runtimeType}: ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _log(
      '[Change] state in ${bloc.runtimeType}: '
      '${change.currentState.runtimeType} -> ${change.nextState.runtimeType}',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _log(
      '[Transition] in ${bloc.runtimeType}: '
      '${transition.event.runtimeType} '
      '(${transition.currentState.runtimeType} -> '
      '${transition.nextState.runtimeType})',
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _log('[Close] ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _log('[Error] in ${bloc.runtimeType}: $error\n$stackTrace');
  }
}

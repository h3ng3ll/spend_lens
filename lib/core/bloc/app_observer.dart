import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc lifecycle logging.
///
/// Logs TYPE NAMES ONLY, never the objects themselves, and only in debug.
/// Two separate defects forced that rule, both caused by the same line shape
/// (`log('... $state')`), which calls freezed's generated `toString()` and
/// prints every field:
///
/// 1. **PII.** `AuthState` carries the signed-in user's real email, so every
///    transition wrote it to the device log in release builds too. Enforced by
///    `test/regression/no_pii_in_logging_test.dart`.
/// 2. **An ANR that killed the app.** `EditProfileState` carries the avatar as
///    a `Uint8List`. Interpolating it renders every byte as a decimal number —
///    a multi-megabyte photo becomes a string several times that size, built
///    twice per transition (current + next) on the main isolate. Tapping Save
///    hung the UI thread long enough for the platform to tombstone the
///    process: `Wrote stack traces to tombstoned` / `dumpMsgWhenAnr`, then
///    `Lost connection to device`.
///
/// The second is why `kDebugMode` alone is not enough and the payload must
/// stay out of the string: the cost is in BUILDING it, not in shipping it.
class AppObserver extends BlocObserver {
  static AppObserver? _singleton;

  AppObserver._();

  factory AppObserver.instance() => _singleton ??= AppObserver._();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (kDebugMode) log('[Create] ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) log('[Event] ${event.runtimeType} in ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      log(
        '[Change] ${bloc.runtimeType}: '
        '${change.currentState.runtimeType} -> '
        '${change.nextState.runtimeType}',
      );
    }
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      log(
        '[Transition] ${bloc.runtimeType} on ${transition.event.runtimeType}: '
        '${transition.currentState.runtimeType} -> '
        '${transition.nextState.runtimeType}',
      );
    }
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (kDebugMode) log('[Close] ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // The error and its stack trace are diagnostics, not state — they carry no
    // model fields and are what makes a failure actionable, so they are logged
    // in full. Only the BLOC is reduced to its type name.
    if (kDebugMode) {
      log(
        '[Error] ${bloc.runtimeType}: $error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

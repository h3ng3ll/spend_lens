import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Application-wide logger.
///
/// Backed by `dart:developer`'s [developer.log], consistent with the bloc
/// observer. Levels map to the standard `package:logging` numeric levels so
/// they render with the expected severity in tooling:
/// DEBUG=500, INFO=800, WARNING=900, ERROR=1000.
///
/// **WARNING and ERROR are ALSO mirrored to stdout** in non-release builds.
/// `developer.log` alone is invisible on a device unless a debugger or
/// `flutter attach` is connected — which is precisely how a silent auth
/// failure stayed undiagnosable: the code logged diligently and the log went
/// nowhere. `debugPrint` reaches `adb logcat -s flutter`, so a plain
/// `flutter build apk --debug` + install is enough to read what went wrong.
class LoggerService {
  static const String _defaultName = 'App';

  /// Mirrors a message to stdout so it lands in logcat / the console.
  ///
  /// Suppressed in release builds: these lines are diagnostics, not telemetry,
  /// and a release build should not narrate itself to the system log.
  void _mirror(String level, String name, String message, Object? error) {
    if (kReleaseMode) return;
    debugPrint(
      '[$level] $name: $message${error == null ? '' : ' | $error'}',
    );
  }

  void debug(
    String message, {
    String name = _defaultName,
  }) {
    developer.log(
      message,
      level: 500,
      name: name,
    );
  }

  void info(
    String message, {
    String name = _defaultName,
  }) {
    developer.log(
      message,
      level: 800,
      name: name,
    );
  }

  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String name = _defaultName,
  }) {
    developer.log(
      message,
      level: 900,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
    _mirror('WARN', name, message, error);
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String name = _defaultName,
  }) {
    developer.log(
      message,
      level: 1000,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
    _mirror('ERROR', name, message, error);
  }
}

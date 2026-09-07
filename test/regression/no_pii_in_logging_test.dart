import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// design_spendlens.md §11 — no PII in logging calls.
///
/// FIXED VIOLATION (found while writing this gate — see the M10 handoff):
/// `AppObserver` used to interpolate `${change.currentState}` /
/// `${transition.nextState}` directly into `dart:developer.log(...)`.
/// Freezed's generated `toString()` prints every field, and `AuthState`
/// carries the signed-in user's real email
/// (`features/auth/presentation/bloc/auth_bloc/auth_state.dart`), so every
/// bloc transition was writing that email to the device log — in every
/// build, not just debug. `AppObserver` now logs `runtimeType` names only
/// and is gated on `kDebugMode`.
///
/// This gate encodes both halves of the fix as structural checks: (1) the
/// bloc observer never string-interpolates a raw `state`/`event`/`change`/
/// `transition` object, only its `.runtimeType`; and (2) `AuthState.email`
/// — the one confirmed PII field in this codebase — is never interpolated
/// anywhere outside its own model/bloc files.
///
/// NOTE ON SCANNING: unlike the other regression gates, this file strips
/// only COMMENTS, not string-literal contents — the very thing under test
/// (`${x.runtimeType}` vs `$x`) lives INSIDE a string interpolation, so a
/// scanner that blanks out string contents (`SourceScanner.readStripped`)
/// would blind itself to the fix it's supposed to verify.
void main() {
  test('AppObserver never logs a raw bloc state/event/change/transition', () {
    final file = File('lib/core/bloc/app_observer.dart');
    expect(file.existsSync(), isTrue);

    final withoutComments = _stripComments(file.readAsStringSync());

    // Forbidden: interpolating the object itself (would call toString()),
    // as opposed to interpolating `<object>.runtimeType`.
    final forbiddenPatterns = [
      RegExp(r'\$state\b(?!\.)'),
      RegExp(r'\$\{state\}'),
      RegExp(r'\$event\b(?!\.)'),
      RegExp(r'\$\{event\}'),
      RegExp(r'\$change\b(?!\.)'),
      RegExp(r'\$\{change\}'),
      RegExp(r'\$\{change\.currentState\}'),
      RegExp(r'\$\{change\.nextState\}'),
      RegExp(r'\$\{transition\.currentState\}'),
      RegExp(r'\$\{transition\.nextState\}'),
    ];

    for (final pattern in forbiddenPatterns) {
      expect(
        pattern.hasMatch(withoutComments),
        isFalse,
        reason: 'AppObserver must never interpolate a raw state/event '
            'object (matched $pattern) — states can carry PII (e.g. '
            'AuthState.email) and freezed toString() prints every field. '
            'Log .runtimeType instead.',
      );
    }

    // Required: it DOES log .runtimeType on every bloc/state/event object it
    // reports — i.e. the fix is actually present, not just the forbidden
    // pattern absent.
    expect(withoutComments.contains('.runtimeType'), isTrue);
  });

  test('AuthState.email is never interpolated outside its own auth files', () {
    final dir = Directory('lib');
    final offenders = <String>[];

    for (final file in dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.g.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))) {
      if (file.path.contains('/features/auth/')) continue;

      final withoutComments = _stripComments(file.readAsStringSync());
      if (RegExp(r'\$\{?\w*\.email\b').hasMatch(withoutComments) &&
          withoutComments.contains('log(')) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'A file outside features/auth/ interpolates an email field '
          'into a log(...) call: $offenders',
    );
  });
}

/// Strips `//` line comments and `/* */` block comments only — string
/// literals are left untouched, since this file inspects interpolation
/// contents.
String _stripComments(String source) {
  final buffer = StringBuffer();
  var i = 0;
  final len = source.length;
  var inString = false;
  String stringQuote = '';

  while (i < len) {
    final c = source[i];
    final next = i + 1 < len ? source[i + 1] : '';

    if (!inString && c == '/' && next == '/') {
      while (i < len && source[i] != '\n') {
        i++;
      }
      continue;
    }

    if (!inString && c == '/' && next == '*') {
      i += 2;
      while (i < len &&
          !(source[i] == '*' && i + 1 < len && source[i + 1] == '/')) {
        i++;
      }
      i += 2;
      continue;
    }

    if (!inString && (c == "'" || c == '"')) {
      inString = true;
      stringQuote = c;
      buffer.write(c);
      i++;
      continue;
    }

    if (inString && c == stringQuote) {
      inString = false;
      buffer.write(c);
      i++;
      continue;
    }

    if (inString && c == r'\' && i + 1 < len) {
      buffer.write(c);
      buffer.write(source[i + 1]);
      i += 2;
      continue;
    }

    buffer.write(c);
    i++;
  }
  return buffer.toString();
}

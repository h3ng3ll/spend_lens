import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// `~/.claude/rules/splash_screen_rules.md` HARD RULE — exactly ONE
/// `FlutterNativeSplash.remove()` call app-wide, unconditional and
/// synchronous, called as the FIRST statement after `super.initState()`.
///
/// DEVIATION FROM THE RULE'S LETTER, IN SERVICE OF ITS INTENT (see the doc
/// comment on `main()` in `lib/main.dart` for the full reasoning): this
/// project's `resolveRedirect` (`init_router/init_router.dart`) is a pure,
/// synchronous function evaluated by GoRouter on the very first navigation
/// to `initialLocation: '/'`, and it redirects away in BOTH branches
/// (`!onboardingCompleted` → `/onboarding`; completed → `/home`) before the
/// `/` route's `buildPage` — and therefore any widget built there — is ever
/// invoked. A splash-screen-owned `remove()` is provably unreachable code in
/// this project: confirmed on-device, the native splash never lifted
/// (`dumpsys SurfaceFlinger` still showed the splash layer on top 20+
/// seconds after launch).
///
/// `remove()` now lives in `_SpendLensAppState.initState()` in `main.dart`
/// instead: `SpendLensApp` is the ROOT widget passed to `runApp`, so its
/// `initState()` is the earliest point GUARANTEED to run on every cold
/// start, before GoRouter evaluates any redirect and before the first frame
/// paints. This gate asserts THAT contract, not the old splash-route one —
/// asserting a call site the app can never reach would make the gate pass
/// while the underlying defect (the app hangs on the native splash forever)
/// remains.
void main() {
  test('FlutterNativeSplash.remove() appears exactly once app-wide, in '
      'main.dart', () {
    final offenders = <String>[];
    var removeCount = 0;
    File? removeFile;

    for (final file in SourceScanner.libDartFiles()) {
      final stripped = SourceScanner.readStripped(file);
      final matches =
          RegExp(r'FlutterNativeSplash\.remove\(').allMatches(stripped);
      if (matches.isNotEmpty) {
        removeCount += matches.length;
        removeFile = file;
        if (!file.path.endsWith('main.dart')) {
          offenders.add(file.path);
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'FlutterNativeSplash.remove() must live only in '
          'lib/main.dart, found also in: $offenders',
    );
    expect(
      removeCount,
      1,
      reason: 'FlutterNativeSplash.remove() must be called EXACTLY ONCE '
          'app-wide; found $removeCount call(s).',
    );
    expect(removeFile, isNotNull);
  });

  test(
    'lib/core/routes/splash_page/ no longer exists (dead, unreachable code '
    'that used to own the only remove() call)',
    () {
      final dir = Directory('lib/core/routes/splash_page');
      expect(
        dir.existsSync(),
        isFalse,
        reason: 'splash_page/ was deleted because resolveRedirect makes its '
            'build() unreachable on every cold start; a route folder must '
            'not be resurrected as the home of a critical lifecycle call '
            'it can never execute.',
      );
    },
  );

  test('remove() is the first statement after super.initState() in '
      '_SpendLensAppState', () {
    final file = File('lib/main.dart');
    expect(file.existsSync(), isTrue);

    final stripped = SourceScanner.readStripped(file);

    final classIndex = stripped.indexOf('class _SpendLensAppState');
    expect(
      classIndex,
      greaterThanOrEqualTo(0),
      reason: 'No _SpendLensAppState found in main.dart',
    );

    final initStateMatch = RegExp(r'void\s+initState\s*\(\s*\)\s*\{')
        .firstMatch(stripped.substring(classIndex));
    expect(
      initStateMatch,
      isNotNull,
      reason: 'No initState() found in _SpendLensAppState',
    );

    final bodyStart = classIndex + initStateMatch!.end;
    final closeIndex = _matchingBrace(stripped, bodyStart - 1);
    final body = stripped.substring(bodyStart, closeIndex).trim();

    final statements = body
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    expect(
      statements.first,
      'super.initState()',
      reason: 'super.initState() must be the first statement in '
          'initState().',
    );
    expect(
      statements[1],
      'FlutterNativeSplash.remove()',
      reason: 'FlutterNativeSplash.remove() must be the statement '
          'IMMEDIATELY after super.initState(), with nothing between — '
          'found: ${statements[1]}',
    );
  });

  test('remove() is never awaited, never gated, never deferred', () {
    final file = File('lib/main.dart');
    final stripped = SourceScanner.readStripped(file);

    expect(stripped.contains('await FlutterNativeSplash.remove'), isFalse);

    final removeLine = stripped
        .split('\n')
        .firstWhere((l) => l.contains('FlutterNativeSplash.remove('));
    expect(removeLine.trim(), 'FlutterNativeSplash.remove();');
  });

  test('main() calls preserve() and never remove()', () {
    final file = File('lib/main.dart');
    expect(file.existsSync(), isTrue);

    final stripped = SourceScanner.readStripped(file);
    expect(stripped.contains('FlutterNativeSplash.preserve('), isTrue);

    // preserve() must be called from main(), strictly before the
    // _SpendLensAppState class (i.e. not itself inside the class that owns
    // remove()).
    final preserveIndex = stripped.indexOf('FlutterNativeSplash.preserve(');
    final classIndex = stripped.indexOf('class _SpendLensAppState');
    expect(preserveIndex, greaterThanOrEqualTo(0));
    expect(
      preserveIndex,
      lessThan(classIndex),
      reason: 'preserve() must be called from main(), before '
          '_SpendLensAppState is declared.',
    );
  });
}

int _matchingBrace(String source, int openBraceIndex) {
  var depth = 0;
  for (var i = openBraceIndex; i < source.length; i++) {
    if (source[i] == '{') depth++;
    if (source[i] == '}') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return source.length;
}

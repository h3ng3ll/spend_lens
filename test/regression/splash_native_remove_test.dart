import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// `~/.claude/rules/splash_screen_rules.md` HARD RULE — exactly ONE
/// `FlutterNativeSplash.remove()` call app-wide, and it must be the FIRST
/// statement after `super.initState()` in the splash's `initState()`.
/// `main.dart` keeps `preserve()` and ONLY `preserve()`.
void main() {
  test('FlutterNativeSplash.remove() appears exactly once app-wide, in '
      'splash_page.dart', () {
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
        if (!file.path.endsWith('splash_page.dart')) {
          offenders.add(file.path);
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'FlutterNativeSplash.remove() must live only in '
          'splash_page.dart, found also in: $offenders',
    );
    expect(
      removeCount,
      1,
      reason: 'FlutterNativeSplash.remove() must be called EXACTLY ONCE '
          'app-wide; found $removeCount call(s).',
    );
    expect(removeFile, isNotNull);
  });

  test('remove() is the first statement after super.initState()', () {
    final file = File('lib/core/routes/splash_page/splash_page.dart');
    expect(file.existsSync(), isTrue);

    final stripped = SourceScanner.readStripped(file);
    final initStateMatch =
        RegExp(r'void\s+initState\s*\(\s*\)\s*\{').firstMatch(stripped);
    expect(initStateMatch, isNotNull, reason: 'No initState() found');

    final bodyStart = initStateMatch!.end;
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
    final file = File('lib/core/routes/splash_page/splash_page.dart');
    final stripped = SourceScanner.readStripped(file);

    expect(stripped.contains('await FlutterNativeSplash.remove'), isFalse);

    final removeLine = stripped
        .split('\n')
        .firstWhere((l) => l.contains('FlutterNativeSplash.remove('));
    expect(removeLine.trim(), 'FlutterNativeSplash.remove();');
  });

  test('main.dart calls preserve() and never remove()', () {
    final file = File('lib/main.dart');
    expect(file.existsSync(), isTrue);

    final stripped = SourceScanner.readStripped(file);
    expect(stripped.contains('FlutterNativeSplash.preserve('), isTrue);
    expect(stripped.contains('FlutterNativeSplash.remove('), isFalse);
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

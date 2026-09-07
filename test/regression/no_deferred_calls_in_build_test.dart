import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// design_spendlens.md §11 — `addPostFrameCallback` /
/// `Future.delayed` / `Future.microtask` may never appear INSIDE a
/// `build(BuildContext ...)` method. Deferred work belongs in `initState`
/// (`new_category_page.dart`'s focus request) or a service method
/// (`UiMessageService`'s toast auto-dismiss) — never scheduled fresh on
/// every rebuild of `build()`.
///
/// Scoped to `build(` method bodies specifically (found via brace balance,
/// starting at the `build(` call site) rather than the whole file, because
/// legitimate uses of these APIs exist elsewhere in this codebase
/// (`initState`, `Future<void>` service methods) and must not be flagged.
void main() {
  test(
    'no addPostFrameCallback/Future.delayed/Future.microtask inside build()',
    () {
      final offenders = <String>[];
      final forbidden = [
        'addPostFrameCallback',
        'Future.delayed',
        'Future.microtask',
      ];

      for (final file in SourceScanner.libDartFiles()) {
        final stripped = SourceScanner.readStripped(file);

        for (final match in RegExp(r'Widget\s+build\s*\(').allMatches(stripped)) {
          final bodyStart = stripped.indexOf('{', match.end);
          if (bodyStart == -1) continue;

          final body = _extractBalancedBody(stripped, bodyStart);
          for (final pattern in forbidden) {
            if (body.contains(pattern)) {
              offenders.add('${file.path}: $pattern inside build()');
            }
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'Deferred scheduling calls must never live inside build(): '
            '$offenders',
      );
    },
  );
}

/// Returns the substring of [source] from [openBraceIndex] (inclusive) to
/// its matching closing brace (inclusive), by simple depth counting. Good
/// enough once comments/strings are already stripped.
String _extractBalancedBody(String source, int openBraceIndex) {
  var depth = 0;
  for (var i = openBraceIndex; i < source.length; i++) {
    if (source[i] == '{') depth++;
    if (source[i] == '}') {
      depth--;
      if (depth == 0) {
        return source.substring(openBraceIndex, i + 1);
      }
    }
  }
  return source.substring(openBraceIndex);
}

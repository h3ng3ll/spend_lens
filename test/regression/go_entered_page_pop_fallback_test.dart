import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A page reached with `.go()` has NO route to pop — `.go()` REPLACES the
/// stack — so a bare `context.pop()` on it throws
/// `GoError: There is nothing to pop` and leaves the user stranded.
///
/// This shipped three times: Review's back and retake controls, and then
/// Edit-receipt's Cancel button AND its post-save listener (so corrections
/// were written but the screen never closed). Every occurrence looked
/// correct in isolation — the bug lives in the relationship between the
/// NAVIGATION verb at the call site and the POP at the destination, which
/// no single-file review catches.
///
/// The gate is deliberately narrow: it fires only for pages that are
/// ACTUALLY entered with `.go()` somewhere in the app. Pages reached with
/// `.push()` must keep their bare `pop()` — they have a real route to pop
/// and often must return a value to the caller.
void main() {
  test('every .go()-entered page guards context.pop() with canPop()', () {
    final libDir = Directory('lib');
    final dartFiles = libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.g.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))
        .toList();

    // 1. Which route classes does the app enter with `.go()`?
    final goEntered = <String>{};
    final goCall = RegExp(r'(\w+PageRoute)\s*\([^)]*\)\s*\.go\s*\(');
    for (final file in dartFiles) {
      for (final match in goCall.allMatches(file.readAsStringSync())) {
        goEntered.add(match.group(1)!);
      }
    }
    expect(
      goEntered,
      isNotEmpty,
      reason: 'Expected at least one `.go()` navigation to exist; the '
          'detection regex has probably drifted from the call syntax.',
    );

    // 2. Map each route class to the page widget file it builds.
    final offenders = <String>[];
    for (final routeName in goEntered) {
      // `ReviewPageRoute` -> `review_page`, `EditReceiptPageRoute` ->
      // `edit_receipt_page`.
      final base = routeName.replaceAll(RegExp(r'Route$'), '');
      final snake = base
          .replaceAllMapped(
            RegExp(r'(?<=[a-z0-9])([A-Z])'),
            (m) => '_${m.group(1)}',
          )
          .toLowerCase();

      final pageFile = dartFiles.firstWhere(
        (f) => f.path.endsWith('/$snake.dart'),
        orElse: () => File(''),
      );
      if (pageFile.path.isEmpty) continue;

      final source = _stripComments(pageFile.readAsStringSync());
      if (!source.contains('context.pop()')) continue;
      if (!source.contains('canPop()')) {
        offenders.add('${pageFile.path} (entered via $routeName.go())');
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These pages are entered with `.go()` (which replaces the route '
          'stack) yet call `context.pop()` without a `canPop()` guard, so '
          'the control throws GoError and does nothing:\n'
          '${offenders.join('\n')}',
    );
  });
}

/// Comments are stripped before matching so a doc comment describing the
/// defect cannot satisfy — or trip — the scan.
String _stripComments(String source) => source
    .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
    .split('\n')
    .map((line) {
      final index = line.indexOf('//');
      return index == -1 ? line : line.substring(0, index);
    })
    .join('\n');

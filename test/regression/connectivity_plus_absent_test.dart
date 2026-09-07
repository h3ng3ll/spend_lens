import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// design_spendlens.md §11 / decision 3 — `connectivity_plus` is
/// blacklisted project-wide: this app is offline-first by design, with no
/// connectivity gate and no auto-redirect on reconnect
/// (`init_router.dart`'s `resolveRedirect` doc comment).
void main() {
  test('connectivity_plus is absent from pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(
      pubspec.contains('connectivity_plus'),
      isFalse,
      reason: 'connectivity_plus must never be declared as a dependency.',
    );
  });

  test('connectivity_plus is absent from pubspec.lock', () {
    final lockFile = File('pubspec.lock');
    if (!lockFile.existsSync()) return;

    final lock = lockFile.readAsStringSync();
    expect(
      lock.contains('connectivity_plus'),
      isFalse,
      reason: 'connectivity_plus must never be resolved as a transitive '
          'or direct dependency.',
    );
  });

  test('connectivity_plus is imported nowhere in lib/', () {
    final offenders = <String>[];
    for (final file in SourceScanner.libDartFiles()) {
      final stripped = SourceScanner.readStripped(file);
      if (stripped.contains('connectivity_plus')) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'connectivity_plus must not be imported anywhere in lib/: '
          '$offenders',
    );
  });
}

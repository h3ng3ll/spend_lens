import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// design_spendlens.md §6 — `unawaited(...)` is banned in `lib/`. An
/// un-awaited Future in app code hides a real defect (a lost persistence
/// write, an un-awaited navigation, an error nobody observes) — the exact
/// class of bug `splash_screen_rules.md` and the onboarding
/// `BlocListener` fix (commit `57a3f0f`) both exist to prevent.
void main() {
  test('unawaited( does not appear anywhere in lib/', () {
    final offenders = <String>[];
    for (final file in SourceScanner.libDartFiles()) {
      final stripped = SourceScanner.readStripped(file);
      if (stripped.contains('unawaited(')) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'unawaited(...) is forbidden in lib/ — await the Future '
          'instead: $offenders',
    );
  });
}

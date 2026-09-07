import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// design_spendlens.md §4.5 — the custom toast overlay (`UiMessageService` +
/// `app_toast.dart`) replaces `fluttertoast`; `SnackBar`/`ScaffoldMessenger`
/// remain forbidden project-wide, including inside the rewrite itself.
void main() {
  test('no SnackBar or ScaffoldMessenger usage in lib/', () {
    final offenders = <String>[];
    for (final file in SourceScanner.libDartFiles()) {
      final stripped = SourceScanner.readStripped(file);
      if (stripped.contains('SnackBar') ||
          stripped.contains('ScaffoldMessenger')) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'SnackBar/ScaffoldMessenger are forbidden — use '
          'UiMessageService: $offenders',
    );
  });
}

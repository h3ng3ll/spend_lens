import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// design_spendlens.md binding decision 5 / §11 — "Real OCR on both
/// platforms... No fake is reachable in a shipped build. ... Fakes live
/// only in `test/` and `integration_test/`."
///
/// This is what makes that decision STRUCTURAL rather than aspirational:
/// no `Fake*Ocr` / `MockOcr` / `StubOcr` symbol may exist anywhere under
/// `lib/`. If one ever appears, it means a fake OCR implementation leaked
/// into the shipped app rather than staying confined to tests.
void main() {
  test('no Fake*Ocr/MockOcr/StubOcr symbol anywhere under lib/', () {
    final pattern = RegExp(r'Fake\w*Ocr|MockOcr|StubOcr');
    final offenders = <String>[];

    for (final file in SourceScanner.libDartFiles()) {
      final stripped = SourceScanner.readStripped(file);
      if (pattern.hasMatch(stripped)) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'A fake/mock/stub OCR symbol was found under lib/ — real OCR '
          'implementations only ship; fakes are confined to test/ and '
          'integration_test/: $offenders',
    );
  });
}

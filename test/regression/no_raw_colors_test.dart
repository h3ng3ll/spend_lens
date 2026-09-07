import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// design_spendlens.md §4.1/§4.2 — raw `Color(0xFF...)` literals and
/// `Colors.*` calls are confined to `app_colors.dart`; every other file
/// reads colors through `AppColors` (raw hues) or `AppColorScheme`
/// (semantic tokens).
void main() {
  test('no Color(0xFF...) literal outside app_colors.dart', () {
    final pattern = RegExp(r'Color\(0x');
    final offenders = <String>[];

    for (final file in SourceScanner.libDartFiles()) {
      if (file.path.endsWith('app_colors.dart')) continue;

      final stripped = SourceScanner.readStripped(file);
      if (pattern.hasMatch(stripped)) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'Color(0xFF...) literals belong only in app_colors.dart: '
          '$offenders',
    );
  });

  test('no Colors.* call outside app_colors.dart', () {
    final pattern = RegExp(r'\bColors\.');
    final offenders = <String>[];

    for (final file in SourceScanner.libDartFiles()) {
      if (file.path.endsWith('app_colors.dart')) continue;

      final stripped = SourceScanner.readStripped(file);
      if (pattern.hasMatch(stripped)) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'Colors.* (including Colors.transparent) belongs only in '
          'app_colors.dart — use AppColors.<token> elsewhere: $offenders',
    );
  });
}

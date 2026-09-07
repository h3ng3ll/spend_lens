import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// design_spendlens.md's UI conventions (CLAUDE.md hard bans) — `Icon(Icons.*)`
/// is forbidden everywhere; icons render via `AppSvgIcon` or a bare
/// `SvgPicture.asset` (the two brand-mark logos that must not be
/// single-color tinted — `app_icons.dart`'s doc comment on `googleLogo`).
void main() {
  test('no Icon(Icons.*) usage anywhere in lib/', () {
    final pattern = RegExp(r'Icon\(\s*Icons\.');
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
      reason: 'Icon(Icons.*) is forbidden — use AppSvgIcon or '
          'SvgPicture.asset(AppIcons.x): $offenders',
    );
  });
}

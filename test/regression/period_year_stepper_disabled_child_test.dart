import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// `db:shared-button-disabled-styling-only-recolors-its-own-default-child`
/// — the Period sheet's year stepper is deliberately styled disabled
/// (design_spendlens.md, "Deliberately not built": only the current year is
/// selectable until there is more than one year of data). Its arrow glyph
/// is a CUSTOM child built at the call site, not a shared button's default
/// child, so the disabled coloring must be applied EXPLICITLY here — never
/// inherited from a shared widget's own internal disabled-state logic
/// (which would only recolor that widget's OWN default child and leave
/// this custom glyph unaffected, exactly the recorded bug shape).
void main() {
  test('PeriodYearStepper explicitly colors its custom arrow glyph disabled',
      () {
    final file = File(
      'lib/core/widgets/period_sheet/widgets/period_year_stepper.dart',
    );
    expect(file.existsSync(), isTrue);

    final stripped = SourceScanner.readStripped(file);

    // The arrow glyph is drawn as a bespoke bordered box, not a stock
    // button's default child.
    expect(stripped, contains('_arrow('));
    expect(stripped, contains('BoxShape.circle'));

    // The disabled treatment (scheme.dim) must be applied directly to the
    // custom glyph's own border color, not delegated to a shared button's
    // internal enabled/disabled branching.
    expect(
      stripped,
      contains('scheme.dim'),
      reason: 'The custom arrow glyph must be colored disabled explicitly '
          'at this call site.',
    );

    // Guard: this widget renders the year value as inert text, never a
    // tappable control wired to a live year-change callback — the stepper
    // stays fully inert until there is more than one year of data.
    expect(stripped, isNot(contains('onTap:')));
    expect(stripped, isNot(contains('onPressed:')));
    expect(stripped, isNot(contains('GestureDetector(')));
  });
}

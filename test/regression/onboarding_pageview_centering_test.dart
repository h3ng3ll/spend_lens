import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// `db:min-column-pageview-expanded-top-aligns-void` (4 recorded
/// occurrences, ONBOARDING every time) — a min-size Column inside a
/// PageView page top-aligns and leaves a void below unless
/// `mainAxisAlignment: MainAxisAlignment.center` is set. Each onboarding
/// `PageView` page is `OnboardingStepContent`; this pins the fix
/// structurally so it cannot silently regress.
void main() {
  test('OnboardingStepContent centers its min-size Column', () {
    final file = File(
      'lib/features/onboarding/presentation/pages/onboarding_page/'
      'widgets/onboarding_step_content.dart',
    );
    expect(file.existsSync(), isTrue);

    final stripped = SourceScanner.readStripped(file);

    expect(stripped, contains('MainAxisSize.min'));
    expect(
      stripped,
      contains('MainAxisAlignment.center'),
      reason: 'db:min-column-pageview-expanded-top-aligns-void — the outer '
          'Column of an onboarding PageView page must center, or content '
          'clusters at the top with a void below.',
    );

    // Guard against the "fake fix" of a Spacer/SizedBox filler instead of
    // the real centering alignment (the known-bug entry explicitly forbids
    // this workaround).
    expect(stripped, isNot(contains('Spacer(')));
  });

  test('OnboardingBody wires PageView pages via OnboardingStepContent', () {
    final file = File(
      'lib/features/onboarding/presentation/pages/onboarding_page/'
      'widgets/onboarding_body.dart',
    );
    final stripped = SourceScanner.readStripped(file);

    expect(stripped, contains('PageView'));
    expect(stripped, contains('OnboardingStepContent'));
  });
}

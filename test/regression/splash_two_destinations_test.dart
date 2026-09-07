import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/source_scanner.dart';

/// `~/.claude/rules/splash_screen_rules.md` HARD RULE — two destinations,
/// two NAMED methods, both guarded on `_navigated || !mounted`, and the
/// branch that picks between them has a reachable `else`
/// (`db:splash-stuck-navigation-noop-or-shared-destination`).
void main() {
  test('splash has two distinct named destination methods', () {
    final file = File('lib/core/routes/splash_page/splash_page.dart');
    final stripped = SourceScanner.readStripped(file);

    expect(stripped.contains('void _goHome()'), isTrue);
    expect(stripped.contains('void _goOnboard()'), isTrue);
  });

  test('_goHome routes to HomePageRoute, _goOnboard to OnboardingPageRoute',
      () {
    final file = File('lib/core/routes/splash_page/splash_page.dart');
    final stripped = SourceScanner.readStripped(file);

    final goHomeBody = _methodBody(stripped, 'void _goHome()');
    final goOnboardBody = _methodBody(stripped, 'void _goOnboard()');

    expect(goHomeBody, contains('HomePageRoute()'));
    expect(goHomeBody, isNot(contains('OnboardingPageRoute()')));

    expect(goOnboardBody, contains('OnboardingPageRoute()'));
    expect(goOnboardBody, isNot(contains('HomePageRoute()')));
  });

  test('both destination methods guard on _navigated || !mounted', () {
    final file = File('lib/core/routes/splash_page/splash_page.dart');
    final stripped = SourceScanner.readStripped(file);

    final goHomeBody = _methodBody(stripped, 'void _goHome()');
    final goOnboardBody = _methodBody(stripped, 'void _goOnboard()');

    for (final body in [goHomeBody, goOnboardBody]) {
      expect(body, contains('_navigated'));
      expect(body, contains('!mounted'));
      expect(body, contains('_navigated = true'));
    }
  });

  test('the branch selecting between them has a reachable else', () {
    final file = File('lib/core/routes/splash_page/splash_page.dart');
    final stripped = SourceScanner.readStripped(file);

    final processSplashBody = _methodBody(
      stripped,
      'Future<void> _processSplash()',
    );

    expect(processSplashBody, contains('_goHome()'));
    expect(processSplashBody, contains('_goOnboard()'));
    expect(
      RegExp(r'if\s*\([^)]*\)\s*\{[^}]*_go(Home|Onboard)\(\);\s*\}\s*else\s*\{'
              r'[^}]*_go(Home|Onboard)\(\);\s*\}')
          .hasMatch(processSplashBody),
      isTrue,
      reason: 'The onboardingCompleted branch must be if/else, not two '
          'independent ifs (which would leave a gap or a race).',
    );
  });
}

String _methodBody(String source, String signature) {
  final index = source.indexOf(signature);
  expect(index, greaterThanOrEqualTo(0), reason: 'Method not found: $signature');
  final bodyStart = source.indexOf('{', index);
  var depth = 0;
  for (var i = bodyStart; i < source.length; i++) {
    if (source[i] == '{') depth++;
    if (source[i] == '}') {
      depth--;
      if (depth == 0) return source.substring(bodyStart, i + 1);
    }
  }
  return source.substring(bodyStart);
}

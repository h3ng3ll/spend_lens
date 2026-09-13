import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `privacy_policy_terms_rules.md` §6.1/§6.4: the Privacy Policy and Terms of
/// Use screens must ALWAYS exist and stay reachable. Never deleted, never
/// route-removed, never no-oped, never replaced with a placeholder.
///
/// This project renders them from local assets rather than the contract's
/// `AppConfig`-URL webview — a deviation recorded in `TermsPage`, because none
/// of that infrastructure exists here (no `AppConfig`, no
/// `flutter_inappwebview`, no `scripts/`). The reachability guarantees below
/// are the half of the contract that is NOT conditional on that, so they are
/// asserted mechanically.
void main() {
  String read(String path) => File(path).readAsStringSync();

  const router = 'lib/core/routes/init_router/init_router.dart';
  const legalCard =
      'lib/features/settings/presentation/pages/settings_page/widgets/legal_card.dart';
  const settingsPage =
      'lib/features/settings/presentation/pages/settings_page/settings_page.dart';

  group('both legal screens exist', () {
    test('the page files are present', () {
      expect(
        File(
          'lib/features/settings/presentation/pages/privacy_page/privacy_page.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          'lib/features/settings/presentation/pages/terms_page/terms_page.dart',
        ).existsSync(),
        isTrue,
      );
    });

    test('the body assets are present and non-empty', () {
      for (final asset in const [
        'assets/legal/privacy_policy.md',
        'assets/legal/terms_of_use.md',
      ]) {
        final file = File(asset);
        expect(file.existsSync(), isTrue, reason: '$asset is missing');
        expect(
          file.readAsStringSync().trim(),
          isNotEmpty,
          reason: '$asset must carry the legal text — an empty body is the '
              '"placeholder screen" §6.4 forbids',
        );
      }
    });
  });

  group('both routes are registered', () {
    test('the router declares /privacy and /terms', () {
      final source = read(router);
      expect(source, contains("@TypedGoRoute<PrivacyPageRoute>(path: '/privacy')"));
      expect(source, contains("@TypedGoRoute<TermsPageRoute>(path: '/terms')"));
    });

    test('each route builds its real page, not a stub', () {
      final source = read(router);
      expect(source, contains('appPage(const PrivacyPage())'));
      expect(source, contains('appPage(const TermsPage())'));
    });
  });

  group('navigation is wired, not no-oped', () {
    test('Settings pushes both routes', () {
      final source = read(settingsPage);
      expect(source, contains('PrivacyPageRoute().push(context)'));
      expect(source, contains('TermsPageRoute().push(context)'));
    });

    test('the Legal card renders a row for each', () {
      final source = read(legalCard);
      expect(source, contains('lo.privacy'));
      expect(source, contains('lo.termsOfUse'));
      expect(source, contains('onTap: onPrivacy'));
      expect(source, contains('onTap: onTerms'));
    });

    test('neither row is hidden behind a platform gate', () {
      // The contract's `if (Platform.isIOS)` wrapper is deliberately NOT
      // applied here — it exists only because `termsOfUseAndroidUrl` does not
      // exist as a config field, and this project reads a local asset instead.
      // Asserted so the gate is not reintroduced without revisiting that.
      //
      // Comments are stripped before matching: this file's own doc comment
      // EXPLAINS the gate, and a naive substring search would match that prose
      // and fail on correct code. Only a real `if (Platform.` guard counts.
      expect(_stripComments(read(legalCard)), isNot(contains('Platform.')));
    });
  });

  group('the body text comes from the asset, never from code', () {
    test('each body loads its asset via rootBundle', () {
      final privacy = read(
        'lib/features/settings/presentation/pages/privacy_page/widgets/privacy_body.dart',
      );
      final terms = read(
        'lib/features/settings/presentation/pages/terms_page/widgets/terms_body.dart',
      );

      expect(privacy, contains("'assets/legal/privacy_policy.md'"));
      expect(privacy, contains('rootBundle.loadString'));
      expect(terms, contains("'assets/legal/terms_of_use.md'"));
      expect(terms, contains('rootBundle.loadString'));
    });

    test('the assets directory is declared in pubspec', () {
      expect(read('pubspec.yaml'), contains('assets/legal/'));
    });
  });
}

/// Removes `//` line comments and `/* */` blocks so a prose mention of a
/// forbidden pattern cannot trip a scan — the same precaution
/// `no_commented_code_rules.md` describes for this repo's other source gates.
String _stripComments(String source) => source
    .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
    .split('\n')
    .map((line) {
      final index = line.indexOf('//');
      return index == -1 ? line : line.substring(0, index);
    })
    .join('\n');

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// design_spendlens.md §4.4 / binding decision 4 — all 7 languages (en, ro,
/// ru, uk, es, de, fr) must carry the SAME key set. Asserts equality of the
/// key sets across every ARB file, never a hardcoded count — a count alone
/// would pass if two files each dropped a different key while staying the
/// same size.
void main() {
  test('all 7 ARB locale files declare the exact same key set', () {
    const locales = ['en', 'ro', 'ru', 'uk', 'es', 'de', 'fr'];
    const dir = 'lib/core/resources/translations';

    final keySets = <String, Set<String>>{};
    for (final locale in locales) {
      final file = File('$dir/app_$locale.arb');
      expect(file.existsSync(), isTrue, reason: '${file.path} is missing');

      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final keys = json.keys.where((k) => !k.startsWith('@')).toSet();
      keySets[locale] = keys;
    }

    final reference = keySets['en']!;
    expect(reference, isNotEmpty);

    for (final locale in locales) {
      if (locale == 'en') continue;

      final keys = keySets[locale]!;
      final missing = reference.difference(keys);
      final extra = keys.difference(reference);

      expect(
        missing,
        isEmpty,
        reason: 'app_$locale.arb is missing keys present in app_en.arb: '
            '$missing',
      );
      expect(
        extra,
        isEmpty,
        reason: 'app_$locale.arb has keys not present in app_en.arb: $extra',
      );
    }
  });
}

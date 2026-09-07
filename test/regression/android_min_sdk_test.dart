import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the Android build configuration that no Dart test could otherwise
/// see.
///
/// This gate exists because of an observed failure, not a hypothetical one: a
/// fully green suite once coexisted with an app that **could not be installed
/// at all**, because `minSdk` sat below the floor a dependency requires and
/// the manifest merge failed. Every test in the suite passed, because not one
/// of them read `build.gradle.kts`.
///
/// The floors below are the real, published requirements of the plugins this
/// app depends on. `apphud` is the binding constraint at 26.
const int _kRequiredMinSdk = 26;

void main() {
  group('android/app/build.gradle.kts', () {
    late final String gradle;

    setUpAll(() {
      final file = File('android/app/build.gradle.kts');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'android/app/build.gradle.kts must exist',
      );
      gradle = file.readAsStringSync();
    });

    test('declares minSdk explicitly, never flutter.minSdkVersion', () {
      expect(
        gradle,
        contains('minSdk'),
        reason: 'minSdk must be declared',
      );
      expect(
        RegExp(r'minSdk\s*=\s*flutter\.minSdkVersion').hasMatch(gradle),
        isFalse,
        reason:
            'minSdk must be an explicit literal. Inheriting '
            "flutter.minSdkVersion silently tracks the SDK's default and can "
            'drop below a dependency floor, which fails the manifest merge at '
            'install time — invisible to every Dart test.',
      );
    });

    test('minSdk is at or above every dependency floor (apphud needs 26)', () {
      final match = RegExp(r'minSdk\s*=\s*(\d+)').firstMatch(gradle);
      expect(
        match,
        isNotNull,
        reason: 'minSdk must be assigned an integer literal',
      );

      final minSdk = int.parse(match!.group(1)!);
      expect(
        minSdk,
        greaterThanOrEqualTo(_kRequiredMinSdk),
        reason:
            'minSdk $minSdk is below $_kRequiredMinSdk. Floors: apphud 26, '
            'camerax 23, mlkit 21. Below the highest floor the manifest merge '
            'fails and the APK cannot be installed, while the Dart suite stays '
            'green.',
      );
    });
  });
}

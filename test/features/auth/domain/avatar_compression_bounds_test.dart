import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The avatar must be RESIZED, not only re-compressed.
///
/// **The crash this exists for.** `compressToTargetSize` originally had no
/// resize parameter, so quality was its only lever. A full-resolution phone
/// photo (4000×3000) therefore ran every quality step down to the floor,
/// each one decoding and re-encoding millions of pixels, to reach a 100 KB
/// avatar budget. That blocked long enough for Android to raise an ANR
/// (`Wrote stack traces to tombstoned`) and kill the app mid-save.
///
/// A source-level check rather than a pixel test: `flutter_image_compress` is
/// platform code with no implementation under `flutter_tester`, so the real
/// call cannot run here. What IS verifiable — and what actually regressed — is
/// that the avatar path passes a bound and the receipt path does not.
void main() {
  String read(String path) => File(path).readAsStringSync();

  const service = 'lib/core/services/image_compression_service.dart';
  const avatarUseCase =
      'lib/features/auth/domain/use_cases/upload_avatar_use_case.dart';

  test('the compressor accepts a dimension bound', () {
    expect(read(service), contains('int? maxDimension'));
  });

  test('the bound reaches the plugin as minWidth/minHeight', () {
    // The plugin's `minWidth`/`minHeight` are its names for a MAXIMUM: it
    // scales down to fit and never scales up. A bound accepted but not
    // forwarded would leave the ANR in place while looking fixed.
    final source = read(service);
    expect(source, contains('minWidth:'));
    expect(source, contains('minHeight:'));
    expect(source, contains('maxDimension ??'));
  });

  test('the avatar upload passes a bound', () {
    final source = read(avatarUseCase);
    expect(
      source,
      contains('maxDimension:'),
      reason: 'without this, quality is the only lever and the save ANRs',
    );
  });

  test('the avatar bound is small enough to matter', () {
    final source = read(avatarUseCase);
    final match = RegExp(
      r'_kAvatarMaxDimension = (\d+)',
    ).firstMatch(source);

    expect(match, isNotNull, reason: 'the bound must be a named constant');

    final dimension = int.parse(match!.group(1)!);
    // The avatar renders at 96dp; 512 covers 3x with room to spare. Anything
    // near a camera's native resolution would not avoid the work that ANRd.
    expect(dimension, lessThanOrEqualTo(1024));
    expect(dimension, greaterThanOrEqualTo(256));
  });

  test('a resize request is not short-circuited by the size check', () {
    // A small file can still be 4000px wide. Returning it unchanged because it
    // already fits the byte budget would hand back the full-resolution image
    // the caller explicitly asked to bound.
    expect(
      read(service),
      contains('maxDimension == null'),
      reason: 'the early return must consider the resize request',
    );
  });

  test('receipts deliberately pass NO bound', () {
    // Receipt resolution is what keeps printed text legible when the user
    // opens the photo. Bounding it here would be a silent quality regression
    // in a different feature.
    final uploadPhotos = read(
      'lib/features/sync/domain/use_cases/upload_receipt_photos_use_case.dart',
    );
    expect(uploadPhotos, isNot(contains('maxDimension')));
  });
}

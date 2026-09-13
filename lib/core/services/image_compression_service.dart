import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Compresses a receipt photo before upload.
///
/// This is what makes the cloud quota mean something: an uncompressed phone
/// photo is 3-6 MB, so the 100 MB free tier would hold ~20 receipts. At the
/// [kTargetSizeKB] budget below it holds roughly 500, and the usage figure the
/// Profile screen reports is a real measured number rather than an estimate.
///
/// Ported from the sinergy_hub template's `ImageService.compressToTargetSize`.
class ImageCompressionService {
  /// Per-photo budget. A receipt is text on paper: legibility survives heavy
  /// JPEG compression far better than a photograph would.
  static const int kTargetSizeKB = 200;

  /// Starting quality, and the floor below which further loss is not worth
  /// the illegibility (OCR has already run by upload time, but the user can
  /// still open the photo).
  static const int _kStartQuality = 90;
  static const int _kMinQuality = 20;
  static const int _kQualityStep = 10;

  /// The plugin requires a positive bound, so "no limit" is expressed as a
  /// value no phone camera exceeds rather than as null.
  static const int _kNoDimensionLimit = 100000;

  const ImageCompressionService();

  /// Returns [input] re-encoded as JPEG at or under [kTargetSizeKB] where
  /// achievable, stepping quality down until it fits or the floor is reached.
  ///
  /// [maxDimension] bounds the longer edge. Receipts deliberately pass none —
  /// their resolution is what keeps the printed text legible when the user
  /// opens the photo. An avatar rendered at 96dp has no such need, and
  /// resizing it first is what keeps this off the ANR path.
  ///
  /// Returns the smallest result produced rather than the last one, so a
  /// non-monotonic encoder can never make the output larger than a step we
  /// already had. If every attempt fails, the original bytes are returned —
  /// an unshrinkable photo is still worth backing up.
  Future<Uint8List> compressToTargetSize(
    Uint8List input, {
    int targetSizeKB = kTargetSizeKB,
    int? maxDimension,
  }) async {
    final targetBytes = targetSizeKB * 1024;
    // The size check cannot short-circuit a RESIZE request: a small file can
    // still be 4000px wide, and returning it unchanged would hand the caller
    // the full-resolution image it explicitly asked to bound.
    if (input.lengthInBytes <= targetBytes && maxDimension == null) {
      return input;
    }

    Uint8List? best;

    for (
      var quality = _kStartQuality;
      quality >= _kMinQuality;
      quality -= _kQualityStep
    ) {
      final attempt = Uint8List.fromList(
        await FlutterImageCompress.compressWithList(
          input,
          quality: quality,
          format: CompressFormat.jpeg,
          // Bounds the LONGER edge when the caller asks for it. Without a
          // resize, quality is the only lever, so a full-resolution phone
          // photo runs every iteration below — each one decoding and
          // re-encoding millions of pixels. That is what made avatar upload
          // block long enough for Android to raise an ANR.
          //
          // `minWidth`/`minHeight` are the plugin's own names for a maximum:
          // it scales down to fit inside the box and never scales up.
          minWidth: maxDimension ?? _kNoDimensionLimit,
          minHeight: maxDimension ?? _kNoDimensionLimit,
        ),
      );

      if (best == null || attempt.lengthInBytes < best.lengthInBytes) {
        best = attempt;
      }
      if (attempt.lengthInBytes <= targetBytes) break;
    }

    if (best == null) return input;
    return best.lengthInBytes < input.lengthInBytes ? best : input;
  }
}

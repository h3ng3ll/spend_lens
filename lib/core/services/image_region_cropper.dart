import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:image/image.dart' as img;

/// JPEG quality for the cropped region. High, because the crop feeds OCR:
/// the file is only ever as big as the region the user framed, so there is
/// no size pressure worth trading legibility for.
const int _kCropJpegQuality = 92;

/// Crops a captured still down to the region the user framed on screen.
///
/// OCR cost scales with pixel count, and everything outside the scanner's
/// frame is background the user has explicitly excluded — recognising it is
/// wasted work and a source of stray text that the parser then has to
/// ignore. Cropping first makes recognition faster AND more focused.
///
/// Runs on a background isolate: decoding and re-encoding a full camera
/// frame is heavy enough to drop UI frames on the processing sheet.
class ImageRegionCropper {
  const ImageRegionCropper();

  /// Returns the part of [imageBytes] covered by [fraction] — a rect whose
  /// coordinates are FRACTIONS (0–1) of the image's width and height, in
  /// its upright (EXIF-applied) orientation.
  ///
  /// Returns [imageBytes] unchanged when the image cannot be decoded, so a
  /// crop failure never blocks OCR.
  Future<Uint8List> cropToFraction(Uint8List imageBytes, Rect fraction) {
    final left = fraction.left;
    final top = fraction.top;
    final width = fraction.width;
    final height = fraction.height;

    return Isolate.run(
      () => _crop(imageBytes, left, top, width, height),
    );
  }
}

Uint8List _crop(
  Uint8List bytes,
  double left,
  double top,
  double width,
  double height,
) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;

  // Camera stills often store rotation only in the EXIF tag. Baking it in
  // first means the fractions — measured against the upright on-screen
  // preview — land on the same pixels here.
  final upright = img.bakeOrientation(decoded);
  final imageWidth = upright.width;
  final imageHeight = upright.height;

  final x = (left * imageWidth).round().clamp(0, imageWidth - 1);
  final y = (top * imageHeight).round().clamp(0, imageHeight - 1);
  final cropWidth = (width * imageWidth).round().clamp(1, imageWidth - x);
  final cropHeight = (height * imageHeight).round().clamp(1, imageHeight - y);

  final cropped = img.copyCrop(
    upright,
    x: x,
    y: y,
    width: cropWidth,
    height: cropHeight,
  );
  return img.encodeJpg(cropped, quality: _kCropJpegQuality);
}

import 'package:flutter/services.dart';

import 'i_receipt_detector.dart';

/// The single, platform-agnostic implementation of [IReceiptDetector],
/// backed by the SAME `com.hengell.spendlens/ocr` channel as
/// [MethodChannelOcrService] (design_spendlens.md §6 — one contract, one
/// impl, native handlers differ, never a `Platform.isX` branch here).
class MethodChannelReceiptDetector implements IReceiptDetector {
  static const _channel = MethodChannel('com.hengell.spendlens/ocr');

  @override
  Future<Rect?> detectReceiptRect(Uint8List imageBytes) async {
    // design_spendlens.md §24: detection failure never blocks OCR — both a
    // native `null` result AND an unimplemented native method surface as
    // `null` here, which every caller already treats as "proceed on the
    // original image".
    try {
      final raw = await _channel.invokeMethod<Map<Object?, Object?>>(
        'detectReceiptRect',
        {'imageBytes': imageBytes},
      );
      if (raw == null) return null;

      return Rect.fromLTWH(
        (raw['left'] as num?)?.toDouble() ?? 0.0,
        (raw['top'] as num?)?.toDouble() ?? 0.0,
        (raw['width'] as num?)?.toDouble() ?? 0.0,
        (raw['height'] as num?)?.toDouble() ?? 0.0,
      );
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Future<Uint8List> cropPerspective(Uint8List imageBytes, Rect rect) async {
    try {
      final result = await _channel.invokeMethod<Uint8List>(
        'cropPerspective',
        {
          'imageBytes': imageBytes,
          'left': rect.left,
          'top': rect.top,
          'width': rect.width,
          'height': rect.height,
        },
      );
      return result ?? imageBytes;
    } on PlatformException {
      return imageBytes;
    } on MissingPluginException {
      return imageBytes;
    }
  }
}

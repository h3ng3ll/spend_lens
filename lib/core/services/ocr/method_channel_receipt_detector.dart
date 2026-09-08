import 'dart:async';

import 'package:flutter/services.dart';

import '../logger_service.dart';
import 'i_receipt_detector.dart';

/// How long a single `detectReceiptRect` call may run.
///
/// This is the hottest platform-channel call in the app — every throttled
/// preview frame (`ScannerBloc._onPreviewFrame`, gated to one call per
/// `_detectionMinInterval` = 700ms) invokes it. A per-frame probe must
/// resolve well inside that cadence or unbounded calls would stack up
/// faster than the throttle clears them, so this bound is intentionally
/// SHORT — an order of magnitude below the generous 5-10s given to
/// one-shot calls like `Apphud.start` or the OCR channel. A native call
/// that cannot detect a receipt in 1.5s on a live camera frame is not
/// going to usefully detect one at all; timing out and returning `null`
/// (design_spendlens.md §24 — a missed detection never blocks OCR) is
/// strictly better than letting one bad frame silently wedge the stream.
const Duration _kDetectFrameTimeout = Duration(milliseconds: 1500);

/// How long the (comparatively rare, capture-time-only) `cropPerspective`
/// call may run. This runs once per actual capture, not per preview frame,
/// so it gets the same generosity as the other one-shot channel calls.
const Duration _kCropTimeout = Duration(seconds: 10);

/// The single, platform-agnostic implementation of [IReceiptDetector],
/// backed by the SAME `com.hengell.spendlens/ocr` channel as
/// [MethodChannelOcrService] (design_spendlens.md §6 — one contract, one
/// impl, native handlers differ, never a `Platform.isX` branch here).
class MethodChannelReceiptDetector implements IReceiptDetector {
  static const _channel = MethodChannel('com.hengell.spendlens/ocr');

  final LoggerService _loggerService;

  MethodChannelReceiptDetector({required LoggerService loggerService})
    : this._(loggerService);

  MethodChannelReceiptDetector._(this._loggerService);

  @override
  Future<Rect?> detectReceiptRect(Uint8List imageBytes) async {
    // design_spendlens.md §24: detection failure never blocks OCR — a
    // native `null` result, an unimplemented native method, AND a timed-out
    // call all surface as `null` here, which every caller already treats as
    // "proceed on the original image".
    try {
      final raw = await _channel
          .invokeMethod<Map<Object?, Object?>>('detectReceiptRect', {
            'imageBytes': imageBytes,
          })
          .timeout(_kDetectFrameTimeout);
      if (raw == null) return null;

      // TEMPORARY DIAGNOSTIC — delete alongside OCR_DIAG. A bogus crop here
      // silently discards the total/items before OCR ever sees them.
      _loggerService.info(
        'CROP_DIAG rect=${raw['left']},${raw['top']} '
        '${raw['width']}x${raw['height']}',
      );

      return Rect.fromLTWH(
        (raw['left'] as num?)?.toDouble() ?? 0.0,
        (raw['top'] as num?)?.toDouble() ?? 0.0,
        (raw['width'] as num?)?.toDouble() ?? 0.0,
        (raw['height'] as num?)?.toDouble() ?? 0.0,
      );
    } on TimeoutException {
      _loggerService.warning(
        'MethodChannelReceiptDetector.detectReceiptRect did not complete '
        'within ${_kDetectFrameTimeout.inMilliseconds}ms — proceeding as '
        'undetected for this frame.',
      );
      return null;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Future<Uint8List> cropPerspective(Uint8List imageBytes, Rect rect) async {
    try {
      final result = await _channel
          .invokeMethod<Uint8List>('cropPerspective', {
            'imageBytes': imageBytes,
            'left': rect.left,
            'top': rect.top,
            'width': rect.width,
            'height': rect.height,
          })
          .timeout(_kCropTimeout);
      return result ?? imageBytes;
    } on TimeoutException {
      _loggerService.warning(
        'MethodChannelReceiptDetector.cropPerspective did not complete '
        'within ${_kCropTimeout.inSeconds}s — proceeding with the '
        'uncropped image.',
      );
      return imageBytes;
    } on PlatformException {
      return imageBytes;
    } on MissingPluginException {
      return imageBytes;
    }
  }
}

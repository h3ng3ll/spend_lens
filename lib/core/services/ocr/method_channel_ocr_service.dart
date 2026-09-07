import 'dart:async';

import 'package:flutter/services.dart';

import '../logger_service.dart';
import 'ocr_service.dart';
import 'ocr_text_block.dart';

/// How long a single native OCR-channel call may run before this service
/// gives up on it. Bound for the same reason `Apphud.start` and
/// `availableCameras()` are timeout-bound
/// (`sig:unbounded-third-party-sdk-await-before-runapp-hangs-first-frame`):
/// a platform-channel call is a native await this Dart code cannot
/// otherwise cap, and an unbounded one can hang the caller with no
/// exception and no log. [recognizeText] runs on every receipt capture, so
/// this timeout gives the same generosity `Apphud.start` gets — a hung
/// native OCR call is rare but must never freeze the capture flow.
const Duration _kOcrChannelTimeout = Duration(seconds: 10);

/// The single, platform-agnostic implementation of [OcrService], backed by
/// `com.hengell.spendlens/ocr` — the ONE channel contract identical on iOS
/// and Android (design_spendlens.md §6). There is exactly one Dart
/// implementation class because the contract is identical; the platform
/// difference lives entirely in the native handlers
/// (`ios/Runner/Ocr/OcrChannel.swift`,
/// `android/.../ocr/OcrChannel.kt`), never in a `Platform.isX` branch here.
class MethodChannelOcrService implements OcrService {
  static const _channel = MethodChannel('com.hengell.spendlens/ocr');

  final LoggerService _loggerService;

  MethodChannelOcrService({required LoggerService loggerService})
    : this._(loggerService);

  MethodChannelOcrService._(this._loggerService);

  @override
  Future<bool> isAvailable() async {
    try {
      final result = await _channel
          .invokeMethod<bool>('isAvailable')
          .timeout(_kOcrChannelTimeout);
      return result ?? false;
    } on TimeoutException {
      _loggerService.warning(
        'MethodChannelOcrService.isAvailable did not complete within '
        '${_kOcrChannelTimeout.inSeconds}s — reporting unavailable.',
      );
      return false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<List<OcrTextBlock>> recognizeText(Uint8List imageBytes) async {
    // M8 fills in the native bodies; until then the channel returns
    // MethodNotImplemented/UNIMPLEMENTED, which this surfaces as an empty
    // result rather than throwing through to a caller that doesn't exist
    // yet on this milestone.
    try {
      final result = await _channel
          .invokeMethod<List<Object?>>('recognizeText', {
            'imageBytes': imageBytes,
          })
          .timeout(_kOcrChannelTimeout);
      if (result == null) return const [];

      return result
          .whereType<Map<Object?, Object?>>()
          .map(
            (raw) => OcrTextBlock(
              text: raw['text'] as String? ?? '',
              boundingBox: Rect.fromLTWH(
                (raw['left'] as num?)?.toDouble() ?? 0.0,
                (raw['top'] as num?)?.toDouble() ?? 0.0,
                (raw['width'] as num?)?.toDouble() ?? 0.0,
                (raw['height'] as num?)?.toDouble() ?? 0.0,
              ),
              confidence: (raw['confidence'] as num?)?.toDouble() ?? 0.0,
            ),
          )
          .toList(growable: false);
    } on TimeoutException {
      _loggerService.warning(
        'MethodChannelOcrService.recognizeText did not complete within '
        '${_kOcrChannelTimeout.inSeconds}s — returning no text blocks.',
      );
      return const [];
    } on PlatformException {
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }
}

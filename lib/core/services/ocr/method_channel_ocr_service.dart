import 'package:flutter/services.dart';

import 'ocr_service.dart';
import 'ocr_text_block.dart';

/// The single, platform-agnostic implementation of [OcrService], backed by
/// `com.hengell.spendlens/ocr` — the ONE channel contract identical on iOS
/// and Android (design_spendlens.md §6). There is exactly one Dart
/// implementation class because the contract is identical; the platform
/// difference lives entirely in the native handlers
/// (`ios/Runner/Ocr/OcrChannel.swift`,
/// `android/.../ocr/OcrChannel.kt`), never in a `Platform.isX` branch here.
class MethodChannelOcrService implements OcrService {
  static const _channel = MethodChannel('com.hengell.spendlens/ocr');

  @override
  Future<bool> isAvailable() async {
    final result = await _channel.invokeMethod<bool>('isAvailable');
    return result ?? false;
  }

  @override
  Future<List<OcrTextBlock>> recognizeText(Uint8List imageBytes) async {
    // M8 fills in the native bodies; until then the channel returns
    // MethodNotImplemented/UNIMPLEMENTED, which this surfaces as an empty
    // result rather than throwing through to a caller that doesn't exist
    // yet on this milestone.
    try {
      final result = await _channel.invokeMethod<List<Object?>>(
        'recognizeText',
        {'imageBytes': imageBytes},
      );
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
    } on PlatformException {
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }
}

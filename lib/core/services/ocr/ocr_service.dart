import 'dart:typed_data';

import 'ocr_text_block.dart';

/// The on-device OCR contract, identical on both platforms
/// (design_spendlens.md §6: `com.hengell.spendlens/ocr`, `isAvailable` +
/// `recognizeText` — `detectReceiptRect`/`cropPerspective` live on
/// [IReceiptDetector] instead, since they are a distinct concern from text
/// recognition and the native side registers them as separate channel
/// methods; both are declared as ONE contract group here so M8 wires all
/// four without inventing a new method name).
///
/// M7 implements [isAvailable] for real, backed by the native channel.
/// [recognizeText] is declared now so the parser (M8) can be built against a
/// stable interface, but its native body is `UNIMPLEMENTED` until M8 — this
/// is a real interface backed by a real (currently stubbed) native call,
/// never a `Fake*Ocr` under `lib/` (that class of symbol is banned
/// project-wide; fakes live only in `test/fakes/`).
abstract interface class OcrService {
  /// Whether on-device text recognition is available on this device right
  /// now — hardware/engine support only, never a permission check (that is
  /// [IScanCapabilityService]'s job).
  Future<bool> isAvailable();

  /// Recognizes text in [imageBytes], returning one [OcrTextBlock] per
  /// detected line/paragraph with its bounding box (never a single
  /// collapsed `String` — design_spendlens.md §27).
  Future<List<OcrTextBlock>> recognizeText(Uint8List imageBytes);
}

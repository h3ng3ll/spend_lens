part of 'scanner_bloc.dart';

/// Every transition below is driven by a REAL event
/// (design_spendlens.md §8) — never a `Future.delayed`/`Timer` standing in
/// for the prototype's fixed 1800/3300/3800/4900/6000/6900/7600 ms timer
/// chain, which is a SIMULATION and never behavior to port:
///
/// - `searching` → `detected` — [_Detected], fired by the camera preview's
///   own periodic real detector call (`IReceiptDetector.detectReceiptRect`)
///   actually returning bounds.
/// - `detected` → `capturing` — [_Capture], fired by auto-capture (the
///   detector holding a stable rect) OR a shutter tap.
/// - `capturing` → `processing` — [_CaptureCompleted], fired when
///   `CameraController.takePicture()` actually completes.
/// - each of the 4 processing steps — [_ProcessingStepCompleted], fired
///   when THAT pipeline stage's real awaited call actually completes
///   (detect/crop → OCR → parse+normalize → price lookup).
/// - → failed — [_Failed], fired when a stage throws or yields nothing
///   usable.
@freezed
sealed class ScannerEvent with _$ScannerEvent {
  const factory ScannerEvent.reset() = _Reset;

  /// Fired by the camera preview when `IReceiptDetector.detectReceiptRect`
  /// actually returns non-null bounds.
  const factory ScannerEvent.detected(Rect bounds) = _Detected;

  /// Fired by auto-capture (a stable detection held for the design's
  /// threshold) or a shutter tap. Never fired by a timer.
  const factory ScannerEvent.capture() = _Capture;

  /// Fired when `CameraController.takePicture()` actually completes.
  const factory ScannerEvent.captureCompleted(Uint8List imageBytes) =
      _CaptureCompleted;

  /// Fired once per processing step, when THAT stage's real awaited call
  /// completes. The bloc advances `state.processingStep` internally —
  /// callers never pass which step, only that "the current one finished".
  const factory ScannerEvent.processingStepCompleted() =
      _ProcessingStepCompleted;

  /// Fired when a stage throws or OCR yields nothing usable.
  const factory ScannerEvent.failed(String reason) = _Failed;
}

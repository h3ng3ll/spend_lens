part of 'scanner_bloc.dart';

/// Every transition below is driven by a REAL event
/// (design_spendlens.md §8) — never a `Future.delayed`/`Timer` standing in
/// for the prototype's fixed 1800/3300/3800/4900/6000/6900/7600 ms timer
/// chain, which is a SIMULATION and never behavior to port. The UI dispatches
/// intent events only; the bloc owns every service call and every decision
/// about whether/when to run one (BLoC rule A3.7):
///
/// - `searching` → `detected` — [_PreviewFrame] is the UI's raw intent
///   ("a frame arrived"); the bloc rate-limits it and, when it actually
///   calls `IReceiptDetector.detectReceiptRect` and that call returns
///   non-null bounds, emits `detected` itself.
/// - `detected` → `capturing` — [_Capture], fired by auto-capture (the
///   detector holding a stable rect) OR a shutter tap.
/// - `capturing` → `processing` — [_CaptureCompleted], fired when
///   `CameraController.takePicture()` actually completes; the SAME handler
///   then runs the full 4-stage pipeline and emits one
///   `processingStep` advance per real stage completing.
/// - → failed — [_Failed], fired when a stage throws or yields nothing
///   usable.
@freezed
sealed class ScannerEvent with _$ScannerEvent {
  const factory ScannerEvent.reset() = _Reset;

  /// The UI's raw intent that a new camera preview frame is available. The
  /// UI does NOT call the detector itself and does NOT decide whether this
  /// frame should be analyzed — the bloc owns the rate limit
  /// ([ScannerBloc._detectionMinInterval]) and the real
  /// `IReceiptDetector.detectReceiptRect` call, emitting `detected` only
  /// when that call actually returns non-null bounds.
  const factory ScannerEvent.previewFrame(Uint8List imageBytes) = _PreviewFrame;

  /// Fired by auto-capture (a stable detection held for the design's
  /// threshold) or a shutter tap. Never fired by a timer.
  const factory ScannerEvent.capture() = _Capture;

  /// Fired when `CameraController.takePicture()` actually completes. The
  /// bloc runs the full detect/crop → OCR → parse → price-check pipeline
  /// from this single handler (never via a self-dispatched `add()`).
  ///
  /// [cropFraction] is the scanner frame the user had on screen, as
  /// fractions (0–1) of the preview — OCR runs on that region only.
  const factory ScannerEvent.captureCompleted(
    Uint8List imageBytes,
    Rect cropFraction,
  ) = _CaptureCompleted;

  /// Fired when a stage throws or OCR yields nothing usable.
  const factory ScannerEvent.failed(String reason) = _Failed;
}

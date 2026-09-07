import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Rect;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_event.dart';

part 'scanner_state.dart';

part 'scanner_state_ext.dart';

part 'scanner_bloc.freezed.dart';

/// Screen-scoped bloc (design_spendlens.md §5: `registerFactory`, built in
/// `ScannerPage.initState`, closed in `dispose` — never `main()`, per BLoC
/// rule A3.8).
///
/// Drives the scanner's four sub-states as ONE route
/// (design_spendlens.md §5 — `EScannerStatus {searching, detected,
/// capturing, processing, failed}`). Every transition is fired by a REAL
/// event from the widget that owns the camera + pipeline orchestration
/// (`ScannerBody`/`CameraPreviewLayer`) — this bloc holds NO timer of its
/// own and never calls `add()` from inside a handler (BLoC rule A3.10):
/// the caller sequences one `processingStepCompleted()` dispatch per
/// completed real pipeline stage.
///
/// design_spendlens.md §8 — the prototype's fixed timer chain
/// (1800/3300/3800/4900/6000/6900/7600 ms) is a SIMULATION and is never
/// ported as behavior here.
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  static const _totalProcessingSteps = 4;

  ScannerBloc() : super(const ScannerState()) {
    on<_Reset>(_onReset);
    on<_Detected>(_onDetected);
    on<_Capture>(_onCapture);
    on<_CaptureCompleted>(_onCaptureCompleted);
    on<_ProcessingStepCompleted>(_onProcessingStepCompleted);
    on<_Failed>(_onFailed);
  }

  void _onReset(_Reset event, Emitter<ScannerState> emit) {
    emit(const ScannerState());
  }

  /// Fired by the camera preview's own periodic call to
  /// `IReceiptDetector.detectReceiptRect` actually returning bounds — never
  /// a timer.
  void _onDetected(_Detected event, Emitter<ScannerState> emit) {
    if (state.status != EScannerStatus.searching) return;
    emit(
      state.copyWith(
        status: EScannerStatus.detected,
        detectedBounds: event.bounds,
      ),
    );
  }

  /// Fired by auto-capture (a stable detection held) or a shutter tap. A
  /// shutter tap is valid from EITHER `searching` or `detected` — the
  /// design's shutter renders in both states, and the detector genuinely
  /// returning `null` (a legitimate outcome — design_spendlens.md §24, a
  /// missed detection never blocks OCR) must not strand the user unable to
  /// ever capture.
  void _onCapture(_Capture event, Emitter<ScannerState> emit) {
    if (state.status != EScannerStatus.searching &&
        state.status != EScannerStatus.detected) {
      return;
    }
    emit(state.copyWith(status: EScannerStatus.capturing));
  }

  /// Fired when `CameraController.takePicture()` actually completes.
  void _onCaptureCompleted(
    _CaptureCompleted event,
    Emitter<ScannerState> emit,
  ) {
    if (state.status != EScannerStatus.capturing) return;
    emit(state.copyWith(status: EScannerStatus.processing, processingStep: 0));
  }

  /// Fired once per completed real pipeline stage (detect/crop → OCR →
  /// parse+normalize → price lookup). The caller never says which step —
  /// only that "the current one finished" — so this handler owns the
  /// counting, matching how [_totalProcessingSteps] is the only place the
  /// step count is named.
  void _onProcessingStepCompleted(
    _ProcessingStepCompleted event,
    Emitter<ScannerState> emit,
  ) {
    if (state.status != EScannerStatus.processing) return;
    final next = state.processingStep + 1;
    if (next > _totalProcessingSteps) return;
    emit(state.copyWith(processingStep: next));
  }

  void _onFailed(_Failed event, Emitter<ScannerState> emit) {
    emit(
      state.copyWith(status: EScannerStatus.failed, errorMessage: event.reason),
    );
  }
}

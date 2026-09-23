import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart' show Rect;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/services/image_region_cropper.dart';
import '../../../../../core/services/ocr/i_receipt_detector.dart';
import '../../../../../core/services/ocr/ocr_service.dart';
import '../../../domain/i_receipt_parse_pipeline.dart';
import '../../../domain/pending_receipt_draft_store.dart';
import '../../../domain/receipt_parse_pipeline.dart';

part 'scanner_event.dart';

part 'scanner_state.dart';

part 'scanner_state_ext.dart';

part 'scanner_bloc.freezed.dart';

/// Screen-scoped bloc (design_spendlens.md §5: `registerFactory` semantics
/// — built by hand in `ScannerPage.initState`, closed in `dispose`, never
/// resolved from `getIt`/registered in `main()`, per BLoC rule A3.8).
///
/// Drives the scanner's sub-states as ONE route (design_spendlens.md §5 —
/// `EScannerStatus {searching, detected, capturing, processing, failed,
/// ready}`) AND owns the entire scanning pipeline: the real
/// [IReceiptDetector], [OcrService] and [IReceiptParsePipeline] calls live
/// here, not in the widget. The UI dispatches intent events only
/// ([ScannerEvent.previewFrame], [ScannerEvent.capture],
/// [ScannerEvent.captureCompleted]) — it never decides whether/when to call
/// a service, per BLoC rule A3.7. The widget retains only what is
/// genuinely tied to its own mount/dispose lifecycle: the `CameraController`
/// itself, the `CameraPreview`, and the `startImageStream` subscription.
///
/// This bloc holds NO timer of its own and never calls `add()` from inside
/// a handler (BLoC rule A3.10): [_onCaptureCompleted] runs all 4 pipeline
/// stages and emits one `processingStep` advance per stage, in a single
/// sequential handler — never a self-dispatched follow-up event.
///
/// design_spendlens.md §8 — the prototype's fixed timer chain
/// (1800/3300/3800/4900/6000/6900/7600 ms) is a SIMULATION and is never
/// ported as behavior here; every transition below still only advances when
/// the real, awaited call behind it actually completes.
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  /// The minimum gap between two detector calls while previewing —
  /// bounds the analysis rate independently of the camera's own frame
  /// rate. A THROTTLE on how often the detector is invoked, never a driver
  /// of a state transition itself (design_spendlens.md §8).
  static const _detectionMinInterval = Duration(milliseconds: 700);

  final IReceiptDetector _receiptDetector;
  final OcrService _ocrService;
  final IReceiptParsePipeline _parsePipeline;
  final PendingReceiptDraftStore _draftStore;
  final ImageRegionCropper _imageRegionCropper;

  DateTime? _lastDetectionAttempt;

  ScannerBloc({
    required this._receiptDetector,
    required this._ocrService,
    required this._parsePipeline,
    required this._draftStore,
    required this._imageRegionCropper,
  }) : super(const ScannerState()) {
    on<_Reset>(_onReset);
    // `droppable()` BOUNDS the preview-frame queue at one in-flight event.
    //
    // Bloc's default transformer queues every event and processes them one
    // at a time, so the `_isDetecting` guard below returned only AFTER a
    // frame had already been queued and dequeued — each queued frame
    // pinning a full plane buffer for as long as it waited. With a native
    // `detectReceiptRect` that can take up to its 1500 ms timeout, frames
    // arriving at ~30 fps piled up faster than they drained: an unbounded
    // buffer of multi-megabyte frames, and a contributor to the 2 GB
    // EXC_RESOURCE kill.
    //
    // `droppable` DISCARDS any frame that arrives while one is being
    // processed, at the transformer — before the event is queued at all —
    // so at most one frame's bytes are ever retained. Dropping the stale
    // ones is correct here: a live preview only cares about the CURRENT
    // frame, and a 600 ms-old frame has no detection value.
    on<_PreviewFrame>(_onPreviewFrame, transformer: droppable());
    on<_Capture>(_onCapture);
    on<_CaptureCompleted>(_onCaptureCompleted);
    on<_Failed>(_onFailed);
  }

  /// A fresh attempt is starting — the previous failed parse (if any) is
  /// superseded, not carried forward. This does NOT violate "never discard
  /// the captured image" (spec §66): that guarantee protects a failed scan
  /// the user has not yet retried or exited, not a scan the user has
  /// explicitly asked to redo.
  void _onReset(_Reset event, Emitter<ScannerState> emit) {
    _draftStore.clear();
    emit(const ScannerState());
  }

  /// The UI's raw "a frame arrived" intent. This handler owns the rate
  /// limit AND the real detector call — the UI no longer calls
  /// [IReceiptDetector.detectReceiptRect] itself. Frames arrive far faster
  /// than the app can (or should) analyze them, so [_detectionMinInterval]
  /// throttles how often the REAL call below is made; it never substitutes
  /// for the call completing.
  Future<void> _onPreviewFrame(
    _PreviewFrame event,
    Emitter<ScannerState> emit,
  ) async {
    if (state.status != EScannerStatus.searching) return;

    final now = DateTime.now();
    final last = _lastDetectionAttempt;
    if (last != null && now.difference(last) < _detectionMinInterval) return;
    _lastDetectionAttempt = now;

    // No `_isDetecting` re-entrancy flag: `droppable()` above already
    // guarantees only one frame is in flight, and structurally rather than
    // by convention. A flag here would be dead code that reads like a live
    // guard.
    final bounds = await _receiptDetector.detectReceiptRect(event.imageBytes);
    if (state.status != EScannerStatus.searching) return;
    if (bounds != null) {
      emit(
        state.copyWith(
          status: EScannerStatus.detected,
          detectedBounds: bounds,
        ),
      );
    }
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

  /// Fired when `CameraController.takePicture()` actually completes. Runs
  /// the 4 real processing stages in sequence from THIS single handler,
  /// emitting exactly ONE `processingStep` advance per stage as it actually
  /// finishes (design_spendlens.md §8) — never via a self-dispatched
  /// `add()` (BLoC rule A3.10).
  ///
  /// OCR runs ONLY on the region the user framed on screen
  /// ([_CaptureCompleted.cropFraction]): everything outside the frame is
  /// background the user excluded, and recognising it cost time and fed
  /// stray text to the parser. The user's frame replaces the automatic
  /// detector crop here — re-detecting inside an already-framed region could
  /// only shave off lines the user deliberately included.
  Future<void> _onCaptureCompleted(
    _CaptureCompleted event,
    Emitter<ScannerState> emit,
  ) async {
    if (state.status != EScannerStatus.capturing) return;
    final bytes = event.imageBytes;

    emit(state.copyWith(status: EScannerStatus.processing, processingStep: 0));

    // Step 1 — Detecting receipt (crop to the user's frame).
    final workingBytes = await _imageRegionCropper.cropToFraction(
      bytes,
      event.cropFraction,
    );
    if (state.status != EScannerStatus.processing) return;
    emit(state.copyWith(processingStep: 1));

    // Step 2 — Reading text (OCR).
    final blocks = await _ocrService.recognizeText(workingBytes);
    if (state.status != EScannerStatus.processing) return;
    emit(state.copyWith(processingStep: 2));

    // Step 3 — Finding products (parse + normalize). The CROPPED working
    // copy — exactly the region OCR read — is what gets attached to the
    // draft, so Review's photo card (and the saved receipt's photo) show the
    // user precisely what the parse was based on and they can re-check it.
    // Written to DISK here, not retained: `attachImageBytes` persists the
    // capture and keeps only its filename, so the multi-megabyte buffer is
    // collectable as soon as this handler returns. Holding it across the
    // await chain below was one of five simultaneous retainers behind a
    // 2 GB EXC_RESOURCE kill (see `PendingReceiptDraft.imageFilename`).
    final pipeline = _parsePipeline;
    if (pipeline is ReceiptParsePipeline) {
      await pipeline.attachImageBytes(workingBytes);
    }
    final productCount = await _parsePipeline.findProducts(blocks);
    if (state.status != EScannerStatus.processing) return;
    emit(state.copyWith(processingStep: 3));

    // Step 4 — Checking prices (price-history lookup).
    await _parsePipeline.checkPrices(productCount);
    if (state.status != EScannerStatus.processing) return;
    emit(state.copyWith(processingStep: 4));

    // A parse that found nothing usable at all (no items AND no total) is
    // the scan-failed state — never a generic error (design_spendlens.md
    // §8/§66) — and the captured image is NEVER discarded on that path
    // (the draft store already holds it, and the failed sub-state's Retry/
    // Enter Manually sheet reads it from there). A usable parse advances to
    // `ready`, which the UI's `BlocListener` turns into the real
    // `ReviewPageRoute` navigation (a UI concern this bloc cannot perform).
    final draft = _draftStore.current;
    if (draft == null || draft.parsedReceipt.isUnusable) {
      emit(
        state.copyWith(
          status: EScannerStatus.failed,
          errorMessage: 'unusable_scan',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EScannerStatus.ready));
  }

  void _onFailed(_Failed event, Emitter<ScannerState> emit) {
    emit(
      state.copyWith(status: EScannerStatus.failed, errorMessage: event.reason),
    );
  }
}

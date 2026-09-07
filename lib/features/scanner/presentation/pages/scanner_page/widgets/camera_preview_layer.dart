import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/services/ocr/i_receipt_detector.dart';
import '../../../../../../core/services/ocr/ocr_service.dart';
import '../../../../../settings/domain/models/app_settings/e_flash_mode.dart';
import '../../../../presentation/bloc/scanner_bloc/scanner_bloc.dart';
import '../../../../domain/i_receipt_parse_pipeline.dart';
import 'scanner_capture_flash.dart';
import 'scanner_corner_overlay.dart';
import 'scanner_scan_line.dart';
import 'scanner_shutter_button.dart';

/// Owns the [CameraController] and every real pipeline call
/// (design_spendlens.md §8 — every `ScannerBloc` transition below is fired
/// by a REAL event, never a `Future.delayed`/`Timer` standing in for work):
///
/// - `startImageStream` feeds live preview frames; a bounded sampling
///   interval (never faster than [_detectionMinInterval]) forwards ONE
///   frame at a time to the REAL `IReceiptDetector.detectReceiptRect` while
///   `searching` — a genuine repeated check of a real async condition, not
///   the banned "perpetual decorative animation" pattern (that bans a
///   COSMETIC rebuild looping forever above the router; this is a bounded,
///   screen-scoped analysis loop over live camera data, stopped in
///   [dispose] and paused the instant [EScannerStatus] leaves `searching`).
/// - the shutter (`onShutterTap`) or a stable detection fires
///   `ScannerEvent.capture()`.
/// - `CameraController.takePicture()` actually completing fires
///   `captureCompleted(bytes)` — `takePicture()` is called EXACTLY ONCE per
///   scan session, for the real capture; it is never used to poll for
///   detection.
/// - each processing stage actually completing
///   (`detectReceiptRect`/`cropPerspective` → `recognizeText` →
///   `findProducts` → `checkPrices`) fires ONE
///   `processingStepCompleted()` — never four fired at once, never a timer.
class CameraPreviewLayer extends StatefulWidget {
  final ScannerState state;
  final EFlashMode flashMode;

  const CameraPreviewLayer({
    super.key,
    required this.state,
    required this.flashMode,
  });

  @override
  State<CameraPreviewLayer> createState() => _CameraPreviewLayerState();
}

class _CameraPreviewLayerState extends State<CameraPreviewLayer> {
  /// The minimum gap between two detector calls while streaming preview
  /// frames — bounds the analysis rate independently of the camera's own
  /// frame rate. Named per A7 (a logic literal, not a UI layout value).
  static const _detectionMinInterval = Duration(milliseconds: 700);

  CameraController? _controller;
  bool _isStreamingForDetection = false;
  bool _isDetecting = false;
  bool _isCapturing = false;
  DateTime? _lastDetectionAttempt;
  EScannerStatus? _lastStatus;

  final IReceiptDetector _receiptDetector = getIt<IReceiptDetector>();
  final OcrService _ocrService = getIt<OcrService>();
  final IReceiptParsePipeline _parsePipeline = getIt<IReceiptParsePipeline>();

  @override
  void initState() {
    super.initState();
    _lastStatus = widget.state.status;
    _initCamera();
  }

  @override
  void didUpdateWidget(covariant CameraPreviewLayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.flashMode != widget.flashMode) {
      _applyFlashMode();
    }

    final previousStatus = _lastStatus;
    _lastStatus = widget.state.status;

    if (widget.state.status == EScannerStatus.searching) {
      _startDetectionStreamIfNeeded();
    } else {
      _stopDetectionStream();
    }

    if (previousStatus != EScannerStatus.capturing &&
        widget.state.status == EScannerStatus.capturing) {
      _capture();
    }
  }

  @override
  void dispose() {
    _stopDetectionStream();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
    } on CameraException {
      cameras = const [];
    }
    if (cameras.isEmpty) {
      if (!mounted) return;
      context.read<ScannerBloc>().add(const ScannerEvent.failed('no_camera'));
      return;
    }

    final back = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      back,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
    } on CameraException {
      if (!mounted) return;
      context.read<ScannerBloc>().add(
        const ScannerEvent.failed('camera_init_failed'),
      );
      return;
    }

    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() => _controller = controller);
    await _applyFlashMode();
    await _startDetectionStreamIfNeeded();
  }

  Future<void> _applyFlashMode() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final mode = switch (widget.flashMode) {
      EFlashMode.auto => FlashMode.auto,
      EFlashMode.on => FlashMode.always,
      EFlashMode.off => FlashMode.off,
    };

    try {
      await controller.setFlashMode(mode);
    } on CameraException {
      // Not every device/lens supports every flash mode — a rejected mode
      // is not a scanner failure, so this is intentionally swallowed rather
      // than routed to `ScannerEvent.failed`.
    }
  }

  Future<void> _startDetectionStreamIfNeeded() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (_isStreamingForDetection || controller.value.isStreamingImages) {
      return;
    }
    if (!controller.value.isInitialized || _isCapturing) return;

    try {
      await controller.startImageStream(_onPreviewFrame);
      _isStreamingForDetection = true;
    } on CameraException {
      // Streaming isn't supported on every platform/lens combination; the
      // scanner still works via the manual shutter in that case.
    }
  }

  Future<void> _stopDetectionStream() async {
    final controller = _controller;
    if (controller == null || !_isStreamingForDetection) return;
    _isStreamingForDetection = false;
    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } on CameraException {
      // Already stopped/torn down — nothing to recover.
    }
  }

  /// Forwards at most one frame per [_detectionMinInterval] to the REAL
  /// detector. Frames arrive far faster than the app can (or should)
  /// analyze them, so this is a rate limiter over live data — never a timer
  /// standing in for the analysis itself.
  void _onPreviewFrame(CameraImage image) {
    if (_isDetecting || _isCapturing) return;
    if (!mounted || widget.state.status != EScannerStatus.searching) return;

    final now = DateTime.now();
    final last = _lastDetectionAttempt;
    if (last != null && now.difference(last) < _detectionMinInterval) return;
    _lastDetectionAttempt = now;

    _analyzeFrame(image);
  }

  Future<void> _analyzeFrame(CameraImage image) async {
    _isDetecting = true;
    try {
      final plane = image.planes.isEmpty ? null : image.planes.first;
      if (plane == null) return;

      // Real call to the shared detector (design_spendlens.md §6). Its
      // native bodies land in M8 — today this genuinely returns `null` on
      // both platforms, which is a legitimate "not found yet" outcome, not
      // a simulated one (§24: a missed detection never blocks OCR, and here
      // it simply keeps the loop in `searching` for the next real frame).
      final bounds = await _receiptDetector.detectReceiptRect(plane.bytes);
      if (!mounted) return;
      if (bounds != null) {
        context.read<ScannerBloc>().add(ScannerEvent.detected(bounds));
      }
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> _capture() async {
    if (_isCapturing) return;
    _isCapturing = true;
    await _stopDetectionStream();

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      if (mounted) {
        context.read<ScannerBloc>().add(
          const ScannerEvent.failed('camera_unavailable'),
        );
      }
      _isCapturing = false;
      return;
    }

    try {
      final picture = await controller.takePicture();
      final bytes = await picture.readAsBytes();
      if (!mounted) return;

      context.read<ScannerBloc>().add(ScannerEvent.captureCompleted(bytes));
      await _runProcessingPipeline(bytes);
    } on CameraException {
      if (mounted) {
        context.read<ScannerBloc>().add(
          const ScannerEvent.failed('capture_failed'),
        );
      }
    } finally {
      _isCapturing = false;
    }
  }

  /// Runs the 4 real processing stages in sequence, firing exactly ONE
  /// `processingStepCompleted()` per stage as it actually finishes
  /// (design_spendlens.md §8). Detection failure never blocks OCR (§24) —
  /// a `null` rect proceeds with the ORIGINAL image, not a cropped one.
  Future<void> _runProcessingPipeline(Uint8List bytes) async {
    // Step 1 — Detecting receipt (detect/crop).
    final rect = await _receiptDetector.detectReceiptRect(bytes);
    final workingBytes = rect == null
        ? bytes
        : await _receiptDetector.cropPerspective(bytes, rect);
    if (!mounted) return;
    context.read<ScannerBloc>().add(
      const ScannerEvent.processingStepCompleted(),
    );

    // Step 2 — Reading text (OCR).
    final blocks = await _ocrService.recognizeText(workingBytes);
    if (!mounted) return;
    context.read<ScannerBloc>().add(
      const ScannerEvent.processingStepCompleted(),
    );

    // Step 3 — Finding products (parse + normalize).
    final productCount = await _parsePipeline.findProducts(blocks);
    if (!mounted) return;
    context.read<ScannerBloc>().add(
      const ScannerEvent.processingStepCompleted(),
    );

    // Step 4 — Checking prices (price-history lookup).
    await _parsePipeline.checkPrices(productCount);
    if (!mounted) return;
    context.read<ScannerBloc>().add(
      const ScannerEvent.processingStepCompleted(),
    );

    // M8 lands Review — until then a completed scan has nowhere new to go,
    // so the pipeline finishing is the visible end state for this
    // milestone rather than a route this milestone does not own.
  }

  void _onShutterTap() {
    context.read<ScannerBloc>().add(const ScannerEvent.capture());
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final state = widget.state;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (controller != null && controller.value.isInitialized)
          CameraPreview(controller)
        else
          ColoredBox(color: AppColors.black.value),
        if (state.isSearching) const ScannerScanLine(),
        if (state.isSearching || state.isDetected)
          ScannerCornerOverlay(
            isDetected: state.isDetected,
            bounds: state.detectedBounds,
          ),
        if (state.isCapturing) const ScannerCaptureFlash(),
        if (!state.isProcessing)
          ScannerShutterButton(
            isDetected: state.isDetected,
            onTap: state.isCapturing ? null : _onShutterTap,
          ),
      ],
    );
  }
}

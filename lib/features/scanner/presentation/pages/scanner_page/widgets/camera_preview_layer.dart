import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../settings/domain/models/app_settings/e_flash_mode.dart';
import '../../../../presentation/bloc/scanner_bloc/scanner_bloc.dart';
import 'scanner_capture_flash.dart';
import 'scanner_corner_overlay.dart';
import 'scanner_scan_line.dart';
import 'scanner_shutter_button.dart';

/// Owns ONLY the camera-plugin concerns that are genuinely tied to this
/// widget's own mount/dispose lifecycle (design_spendlens.md §8): the
/// [CameraController], the [CameraPreview] surface, and the
/// `startImageStream` subscription. Every real pipeline call — the
/// detector, OCR, parsing and price-check — lives in [ScannerBloc], which
/// this widget only DISPATCHES intent events to
/// (`ScannerEvent.previewFrame`/`capture`/`captureCompleted`/`failed`); it
/// never decides whether/when a service call should run.
///
/// - `startImageStream` feeds live preview frames; each one is forwarded to
///   the bloc as a raw [ScannerEvent.previewFrame] intent — the BLOC applies
///   the [_detectionMinInterval]-equivalent rate limit and calls the REAL
///   `IReceiptDetector.detectReceiptRect`, emitting `detected` itself. This
///   widget does not know the detector exists.
/// - the shutter (`onShutterTap`) or a stable detection fires
///   `ScannerEvent.capture()`.
/// - `CameraController.takePicture()` actually completing fires
///   `captureCompleted(bytes)` — `takePicture()` is called EXACTLY ONCE per
///   scan session, for the real capture; it is never used to poll for
///   detection. The bloc then runs the full processing pipeline from that
///   single event.
/// - a successful pipeline run emits `EScannerStatus.ready`, which a
///   [BlocListener] here turns into the actual `ReviewPageRoute`
///   navigation — the one thing only a widget holding a [BuildContext] can
///   do.
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
  CameraController? _controller;
  bool _isStreamingForDetection = false;
  bool _isCapturing = false;
  EScannerStatus? _lastStatus;

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

  /// Forwards the frame's bytes to the bloc as a raw intent — no rate
  /// limiting and no detector call here. [ScannerBloc._onPreviewFrame] owns
  /// both; this widget only knows a frame arrived.
  void _onPreviewFrame(CameraImage image) {
    if (_isCapturing) return;
    if (!mounted || widget.state.status != EScannerStatus.searching) return;

    final plane = image.planes.isEmpty ? null : image.planes.first;
    if (plane == null) return;

    context.read<ScannerBloc>().add(ScannerEvent.previewFrame(plane.bytes));
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

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/services/logger_service.dart';
import '../../../../../settings/domain/models/app_settings/e_flash_mode.dart';
import '../../../../presentation/bloc/scanner_bloc/scanner_bloc.dart';
import 'scanner_capture_flash.dart';
import 'scanner_frame_area.dart';
import 'scanner_shutter_button.dart';

/// How long `availableCameras()` / `CameraController.initialize()` may run
/// before this widget gives up on camera setup and reports a
/// [ScannerEvent.failed]. Bound for the same reason `Apphud.start` and the
/// scan-capability hardware probe are timeout-bound
/// (`sig:unbounded-third-party-sdk-await-before-runapp-hangs-first-frame`):
/// this is a SECOND, independent call site to the same plugin — the
/// scan-capability probe checks capability before the scanner even opens,
/// this one actually sets up the camera session once it does, and an
/// unbounded await here previously made Home's "Scan Receipt" CTA appear
/// dead.
const Duration _kCameraSetupTimeout = Duration(seconds: 5);

/// Minimum gap between two preview frames being turned into a bloc event.
///
/// This is a MEMORY bound, not a detection-rate preference — see
/// `_CameraPreviewLayerState._onPreviewFrame`. It mirrors `ScannerBloc`'s
/// own `_detectionMinInterval` (700 ms) so a frame that the bloc would
/// throttle away is never allocated into an event in the first place.
/// Keeping it slightly SHORTER than the bloc's interval means this guard
/// only ever drops frames the bloc was going to discard anyway, so it can
/// never starve detection.
const Duration _kFrameDispatchMinInterval = Duration(milliseconds: 600);

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

class _CameraPreviewLayerState extends State<CameraPreviewLayer>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isStreamingForDetection = false;
  bool _isCapturing = false;
  bool _isInitializing = false;
  EScannerStatus? _lastStatus;
  DateTime? _lastFrameDispatch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastStatus = widget.state.status;
    _initCamera();
  }

  /// Re-acquires the camera on resume.
  ///
  /// Two things make this necessary rather than defensive:
  ///
  /// 1. **The permission race.** Answering the OS camera prompt backgrounds
  ///    the app. If `_initCamera` ran before the grant, it failed or timed
  ///    out — and because it only ever ran once from `initState`, nothing
  ///    retried it. The symptom was a scanner that showed a black screen on
  ///    first launch and worked on the second, when permission was already
  ///    granted.
  /// 2. **Android reclaims the camera** from a backgrounded app, so a
  ///    controller that was working before a background is dead after it.
  ///
  /// Only re-inits when there is no live controller, so an ordinary resume
  /// with a healthy session is left completely alone.
  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    super.didChangeAppLifecycleState(appLifecycleState);
    if (appLifecycleState != AppLifecycleState.resumed) return;

    final controller = _controller;
    if (controller != null && controller.value.isInitialized) return;

    // Clear a `failed` left over from the pre-grant attempt BEFORE retrying:
    // the failed sheet is showing and the state machine is parked, so a
    // successful re-init would otherwise acquire a working camera that the
    // user still cannot see past the sheet. `reset` returns the bloc to
    // `searching`, which is also what re-arms the detection stream.
    if (widget.state.isFailed) {
      context.read<ScannerBloc>().add(const ScannerEvent.reset());
    }

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
    WidgetsBinding.instance.removeObserver(this);
    _stopDetectionStream();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    // Re-entrancy guard: `didChangeAppLifecycleState` can fire a resume
    // while the `initState` attempt is still awaiting the plugin, and two
    // concurrent setups would race to assign `_controller` — leaking the
    // loser and leaving the stream attached to a disposed session.
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      await _setUpCamera();
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _setUpCamera() async {
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras().timeout(_kCameraSetupTimeout);
    } on CameraException {
      cameras = const [];
    } on TimeoutException {
      getIt<LoggerService>().warning(
        'CameraPreviewLayer.availableCameras did not complete within '
        '${_kCameraSetupTimeout.inSeconds}s — reporting no_camera.',
      );
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
      await controller.initialize().timeout(_kCameraSetupTimeout);
    } on CameraException {
      if (!mounted) return;
      context.read<ScannerBloc>().add(
        const ScannerEvent.failed('camera_init_failed'),
      );
      return;
    } on TimeoutException {
      getIt<LoggerService>().warning(
        'CameraPreviewLayer.controller.initialize did not complete within '
        '${_kCameraSetupTimeout.inSeconds}s — reporting camera_init_failed.',
      );
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

  /// Forwards the frame's bytes to the bloc as a raw intent — the bloc owns
  /// the detector call and remains the authority on detection timing.
  ///
  /// OOM GUARD — do not remove the interval check below. The bloc's own
  /// throttle runs INSIDE its handler, which is too late to bound memory:
  /// bloc processes events sequentially, so every frame arriving while one
  /// `detectReceiptRect` is awaited is QUEUED, and each queued event retains
  /// a full-resolution plane buffer. At `ResolutionPreset.high` that is
  /// ~2 MB per frame at ~30 fps — about 62 MB/s of retained bytes — which
  /// crossed iOS's 2098 MB high-watermark limit in roughly half a minute of
  /// pointing the scanner at anything (`EXC_RESOURCE RESOURCE_TYPE_MEMORY`,
  /// crashing inside `_platform_memmove`).
  ///
  /// Dropping the frame HERE means the buffer is never copied into an event
  /// and never enqueued, so the queue cannot grow. This duplicates the
  /// bloc's interval deliberately: the bloc's copy decides *when detection
  /// runs*, this one decides *what is allowed to allocate*.
  void _onPreviewFrame(CameraImage image) {
    if (_isCapturing) return;
    if (!mounted || widget.state.status != EScannerStatus.searching) return;

    final now = DateTime.now();
    final last = _lastFrameDispatch;
    if (last != null && now.difference(last) < _kFrameDispatchMinInterval) {
      return;
    }
    _lastFrameDispatch = now;

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
          // Not a bare black box: camera setup can take a moment (and on a
          // first run it waits behind the OS permission prompt), and an
          // unadorned black screen is indistinguishable from a hung app.
          // The failure states get their own sheet; this only covers the
          // legitimate "still acquiring" window.
          ColoredBox(
            color: AppColors.black.value,
            child: state.isFailed
                ? null
                : const Center(child: CircularProgressIndicator()),
          ),
        // One widget now owns the dim mask, the corner brackets and the
        // sweeping line, because all three are laid out against the SAME
        // user-configurable window — splitting them meant three widgets each
        // guessing at the frame's geometry from its own constants.
        if (state.isSearching || state.isDetected)
          ScannerFrameArea(
            isDetected: state.isDetected,
            showScanLine: state.isSearching,
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

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import 'scanner_corner_painter.dart';
import 'scanner_frame_dim_painter.dart';
import 'scanner_frame_handle.dart';
import 'scanner_scan_line.dart';

/// The user-configurable scan window.
///
/// Everything OUTSIDE this rectangle is dimmed to near-black — the camera's
/// live image is only readable inside the frame, which is what makes the
/// scan target unambiguous. The user can:
///
/// - **drag the window** anywhere inside the preview (one-finger drag
///   started inside the frame),
/// - **change the scan WIDTH** by dragging either side grip, and
/// - **change the scan HEIGHT** by dragging the top or bottom grip.
///
/// Both the corner brackets and the sweeping [ScannerScanLine] are laid out
/// against THIS rectangle rather than the full screen, so the scan line can
/// never travel outside the region where the image is actually visible.
///
/// The in-flight rect lives in this widget's own state, not in
/// [ScannerBloc]: it is a pure view-layout affordance with no pipeline
/// meaning (the detector reads the whole frame), and putting an in-flight
/// drag through a bloc would emit a state per pointer move. Only the
/// FINISHED gesture is reported, once, through [onFrameChanged] so the
/// parent can persist it; [savedFraction] seeds the next mount with it.
class ScannerFrameArea extends StatefulWidget {
  final bool isDetected;
  final bool showScanLine;

  /// The last persisted window as fractions (0–1) of the layout box, or
  /// `null` for the default centred frame.
  final Rect? savedFraction;

  /// Reports the window, as fractions of the layout box, when a drag or
  /// resize gesture ends.
  final ValueChanged<Rect> onFrameChanged;

  /// The default window, as fractions of the layout box: centred, 78% wide
  /// and 46% tall, so it is proportional on every screen size instead of a
  /// fixed dp rect that overflows a small phone. Public because the capture
  /// crop uses it when the user never moved the frame.
  static const Rect defaultFraction = Rect.fromLTWH(0.11, 0.27, 0.78, 0.46);

  const ScannerFrameArea({
    super.key,
    required this.isDetected,
    required this.showScanLine,
    required this.savedFraction,
    required this.onFrameChanged,
  });

  @override
  State<ScannerFrameArea> createState() => _ScannerFrameAreaState();
}

class _ScannerFrameAreaState extends State<ScannerFrameArea> {
  /// Smallest the user may pull the window on each axis. A frame below the
  /// minimum cannot hold a receipt line at all; the maximum is the available
  /// area itself, beyond which a grip would be swallowed by the screen edge
  /// and become undraggable.
  static const double _minWidth = 140.0;
  static const double _minHeight = 120.0;
  static const double _edgeMargin = 12.0;

  /// Vertical room reserved for the floating top controls, so a dragged
  /// window cannot park itself underneath them. The shutter floats in the
  /// bottom-right corner and is hit-tested above this widget, so the bottom
  /// only keeps the edge margin plus the system-gesture inset — letting the
  /// frame grow tall enough for a long receipt.
  static const double _topReserved = 96.0;

  static const double _borderRadius = 18.0;
  static const double _dimOpacity = 0.72;

  /// The user's window, in the CURRENT layout box's coordinates.
  ///
  /// `null` until the first layout: the default frame is expressed as
  /// fractions of the available box, which is not known until
  /// [LayoutBuilder] runs.
  Rect? _window;

  /// The box [_window] was last resolved against, so a size change can
  /// rescale the user's frame instead of discarding it.
  Size? _lastSize;

  double get _bottomReserved =>
      _edgeMargin + MediaQuery.paddingOf(context).bottom;

  /// Clamps [rect] back inside the draggable area — applied after every
  /// drag delta AND on every layout change, so a rotation or a keyboard
  /// inset can never strand the window off-screen.
  Rect _constrain(Rect rect, Size size) {
    final minLeft = _edgeMargin;
    final maxRight = size.width - _edgeMargin;
    final minTop = _topReserved;
    final maxBottom = size.height - _bottomReserved;

    final availableWidth = maxRight - minLeft;
    final availableHeight = maxBottom - minTop;

    final width = rect.width.clamp(
      _minWidth.clamp(0.0, availableWidth),
      availableWidth,
    );
    final height = rect.height.clamp(
      _minHeight.clamp(0.0, availableHeight),
      availableHeight,
    );

    final left = rect.left.clamp(minLeft, maxRight - width);
    final top = rect.top.clamp(minTop, maxBottom - height);

    return Rect.fromLTWH(left, top, width, height);
  }

  Rect _initialWindow(Size size) {
    final fraction = widget.savedFraction ?? ScannerFrameArea.defaultFraction;

    return _constrain(
      Rect.fromLTWH(
        fraction.left * size.width,
        fraction.top * size.height,
        fraction.width * size.width,
        fraction.height * size.height,
      ),
      size,
    );
  }

  /// Re-derives the window whenever the laid-out box changes size, keeping
  /// the user's own frame (scaled into the new box) rather than resetting
  /// it — a rotation must not discard a frame the user positioned.
  Rect _resolveWindow(Size size) {
    final previous = _window;
    final previousSize = _lastSize;

    if (previous == null || previousSize == null) return _initialWindow(size);
    if (previousSize == size) return previous;

    final scaleX = size.width / previousSize.width;
    final scaleY = size.height / previousSize.height;

    return _constrain(
      Rect.fromLTWH(
        previous.left * scaleX,
        previous.top * scaleY,
        previous.width * scaleX,
        previous.height * scaleY,
      ),
      size,
    );
  }

  void _onWindowDrag(DragUpdateDetails details, Rect window, Size size) {
    setState(() {
      _lastSize = size;
      _window = _constrain(window.shift(details.delta), size);
    });
  }

  /// Reports the finished gesture's window as fractions of [size], so it
  /// restores proportionally on any screen. Reads `_window`, which the drag
  /// handlers have just refreshed; a gesture that never moved leaves it
  /// `null` and reports nothing.
  void _onDragEnd(Size size) {
    final window = _window;
    if (window == null) return;

    widget.onFrameChanged(
      Rect.fromLTWH(
        window.left / size.width,
        window.top / size.height,
        window.width / size.width,
        window.height / size.height,
      ),
    );
  }

  /// Grips resize SYMMETRICALLY about the window's centre, so growing the
  /// frame keeps the scan target centred on whatever the user already framed
  /// instead of walking the opposite edge across the receipt.
  ///
  /// One handler serves all four grips: [axis] picks which delta component
  /// and which dimension to grow, and [isLeading] flips the sign for the
  /// top/left grips, where dragging toward the edge means GROWING.
  void _onResizeDrag(
    DragUpdateDetails details,
    Rect window,
    Size size, {
    required Axis axis,
    required bool isLeading,
  }) {
    final isHorizontal = axis == Axis.horizontal;
    final travel = isHorizontal ? details.delta.dx : details.delta.dy;
    final delta = (isLeading ? -travel : travel) * 2.0;

    setState(() {
      _lastSize = size;
      _window = _constrain(
        Rect.fromCenter(
          center: window.center,
          width: isHorizontal ? window.width + delta : window.width,
          height: isHorizontal ? window.height : window.height + delta,
        ),
        size,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        // `_resolveWindow` is PURE — it derives the window from the current
        // box without touching state. The cached `_window`/`_lastSize` that
        // the drag handlers read are refreshed by `_onWindowDrag` /
        // `_onWidthDrag` themselves (which receive the resolved window), so
        // `build` never writes state during layout.
        final window = _resolveWindow(size);

        final handleColor = widget.isDetected
            ? scheme.accent
            : AppColors.white.value;

        return Stack(
          children: [
            IgnorePointer(
              child: CustomPaint(
                size: size,
                painter: ScannerFrameDimPainter(
                  window: window,
                  borderRadius: _borderRadius,
                  dimColor: AppColors.black.value.withValues(
                    alpha: _dimOpacity,
                  ),
                ),
              ),
            ),
            Positioned.fromRect(
              rect: window,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (details) => _onWindowDrag(details, window, size),
                onPanEnd: (_) => _onDragEnd(size),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    IgnorePointer(
                      child: CustomPaint(
                        painter: ScannerCornerPainter(
                          color: handleColor,
                          opacity: 1.0,
                          strokeWidth: widget.isDetected ? 3.5 : 3.0,
                        ),
                      ),
                    ),
                    if (widget.showScanLine) const ScannerScanLine(),
                  ],
                ),
              ),
            ),
            _buildHandle(
              window,
              size,
              handleColor,
              axis: Axis.horizontal,
              isLeading: true,
            ),
            _buildHandle(
              window,
              size,
              handleColor,
              axis: Axis.horizontal,
              isLeading: false,
            ),
            _buildHandle(
              window,
              size,
              handleColor,
              axis: Axis.vertical,
              isLeading: true,
            ),
            _buildHandle(
              window,
              size,
              handleColor,
              axis: Axis.vertical,
              isLeading: false,
            ),
          ],
        );
      },
    );
  }

  /// Places one grip centred on the edge it controls. The touch box is
  /// centred ACROSS the edge (half of it overhangs into the dimmed area,
  /// half sits inside the window), so the grab zone is symmetric around the
  /// line the user is actually aiming at.
  Widget _buildHandle(
    Rect window,
    Size size,
    Color color, {
    required Axis axis,
    required bool isLeading,
  }) {
    const across = ScannerFrameHandle.touchExtent / 2.0;
    const along = ScannerFrameHandle.touchLength / 2.0;

    final isHorizontal = axis == Axis.horizontal;
    final edge = switch ((isHorizontal, isLeading)) {
      (true, true) => window.left,
      (true, false) => window.right,
      (false, true) => window.top,
      (false, false) => window.bottom,
    };

    return Positioned(
      left: isHorizontal ? edge - across : window.center.dx - along,
      top: isHorizontal ? window.center.dy - along : edge - across,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) => _onResizeDrag(
          details,
          window,
          size,
          axis: axis,
          isLeading: isLeading,
        ),
        onPanEnd: (_) => _onDragEnd(size),
        child: ScannerFrameHandle(color: color, axis: axis),
      ),
    );
  }
}

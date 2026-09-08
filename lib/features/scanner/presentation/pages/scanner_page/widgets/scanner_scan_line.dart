import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The horizontal glow line sweeping top-to-bottom-and-back while
/// `searching` (`SpendLens.dc.html`'s `slScan` keyframe — 2.4s ease-in-out
/// alternate). Presentation-only duration, kept exactly per
/// design_spendlens.md §8; the controller is scoped to this widget and
/// disposed with it, and only ever mounted while the scanner is actually
/// searching (see `CameraPreviewLayer.build`), so it never runs above the
/// router or outlives this screen.
class ScannerScanLine extends StatefulWidget {
  const ScannerScanLine({super.key});

  @override
  State<ScannerScanLine> createState() => _ScannerScanLineState();
}

class _ScannerScanLineState extends State<ScannerScanLine>
    with SingleTickerProviderStateMixin {
  static const _scanDuration = Duration(milliseconds: 2400);
  static const _topFraction = 0.06;
  static const _bottomFraction = 0.92;

  late final AnimationController _controller;
  late final Animation<double> _position;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _scanDuration)
      ..repeat(reverse: true);
    _position = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ).drive(Tween(begin: _topFraction, end: _bottomFraction));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    // `Positioned` is the OUTERMOST widget here, so it lands as a direct
    // child of `CameraPreviewLayer`'s `Stack`. It is a `ParentDataWidget`:
    // it hands `StackParentData` to whatever render object sits directly
    // above it, so any widget between it and the `Stack` breaks the
    // relationship. Previously `IgnorePointer`/`LayoutBuilder`/
    // `AnimatedBuilder` sat in between and the frame threw
    // "Incorrect use of ParentDataWidget" on every animation tick —
    // `LayoutBuilder`'s render box accepts only `BoxParentData`.
    //
    // `Positioned.fill` + `heightFactor`-free fractional placement replaces
    // the `LayoutBuilder`: `top`/`bottom` are resolved against the Stack's
    // own height by the Stack itself, so the sweep needs no measured
    // `constraints.maxHeight` of its own. `IgnorePointer` moves INSIDE, and
    // `AnimatedBuilder` now rebuilds only the aligned child rather than the
    // parent-data widget.
    return Positioned(
      left: 44.0,
      right: 44.0,
      top: 0.0,
      bottom: 0.0,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _position,
          builder: (context, child) {
            return Align(
              alignment: Alignment(0.0, _position.value * 2.0 - 1.0),
              child: child,
            );
          },
          child: AppContainer(
            height: 2.0,
            color: scheme.accent,
            boxShadow: [
              BoxShadow(
                color: scheme.accent.withValues(alpha: 0.55),
                blurRadius: 18.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

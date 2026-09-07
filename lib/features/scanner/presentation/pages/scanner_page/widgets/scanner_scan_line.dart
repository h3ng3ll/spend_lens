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

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _position,
            builder: (context, child) {
              return Positioned(
                left: 44.0,
                right: 44.0,
                top: _position.value * constraints.maxHeight,
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
              );
            },
          );
        },
      ),
    );
  }
}

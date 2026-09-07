import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_colors.dart';

/// The white flash that plays once when a photo is captured
/// (`SpendLens.dc.html`'s `slFlash` — 120ms). A shutter effect, not a task:
/// it plays exactly ONCE (`forward()`, never `repeat()`) and is only ever
/// mounted while `EScannerStatus.capturing` (see `CameraPreviewLayer.build`),
/// so it disposes itself the instant that state ends.
class ScannerCaptureFlash extends StatefulWidget {
  const ScannerCaptureFlash({super.key});

  @override
  State<ScannerCaptureFlash> createState() => _ScannerCaptureFlashState();
}

class _ScannerCaptureFlashState extends State<ScannerCaptureFlash>
    with SingleTickerProviderStateMixin {
  static const _flashDuration = Duration(milliseconds: 120);

  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _flashDuration)
      ..forward();
    _opacity = Tween<double>(
      begin: 0.9,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _opacity,
        builder: (context, _) => Opacity(
          opacity: _opacity.value,
          child: ColoredBox(color: AppColors.white.value),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The bottom shutter control, present in every non-processing sub-state
/// (`SpendLens.dc.html`'s all three camera artboards show it). Breathes
/// (`slBreathe`, 1.4s) only once a receipt is [isDetected] — the design's
/// `shutterDetected` is the only variant with `animation: slBreathe`; the
/// plain searching shutter is static. The breathing controller is scoped to
/// this widget and only ever runs while [isDetected] is true.
///
/// Positioned above the bottom system-gesture inset via
/// [MediaQuery.paddingOf] — never flush to `bottom: 0`, or the control sits
/// in the gesture-nav cutout and looks tappable while missing every tap
/// (chronic bug `control-rendered-inside-the-system-cutout-inset-is-untappable`).
class ScannerShutterButton extends StatefulWidget {
  final bool isDetected;
  final VoidCallback? onTap;

  const ScannerShutterButton({
    super.key,
    required this.isDetected,
    required this.onTap,
  });

  @override
  State<ScannerShutterButton> createState() => _ScannerShutterButtonState();
}

class _ScannerShutterButtonState extends State<ScannerShutterButton>
    with SingleTickerProviderStateMixin {
  static const _breatheDuration = Duration(milliseconds: 1400);
  static const _ringSize = 76.0;
  static const _knobSize = 60.0;
  static const _bottomOffset = 64.0;

  late final AnimationController _breatheController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      vsync: this,
      duration: _breatheDuration,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
    _syncBreathe();
  }

  @override
  void didUpdateWidget(covariant ScannerShutterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDetected != widget.isDetected) _syncBreathe();
  }

  void _syncBreathe() {
    if (widget.isDetected) {
      _breatheController.repeat(reverse: true);
    } else {
      _breatheController.stop();
      _breatheController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: _bottomOffset + bottomInset,
      child: Center(
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: _scale,
            builder: (context, child) => Transform.scale(
              scale: widget.isDetected ? _scale.value : 1.0,
              child: child,
            ),
            child: AppContainer(
              width: _ringSize,
              height: _ringSize,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.isDetected ? scheme.accent : AppColors.white.value,
                width: 4.0,
              ),
              alignment: Alignment.center,
              child: AppContainer(
                width: _knobSize,
                height: _knobSize,
                shape: BoxShape.circle,
                color: AppColors.white.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

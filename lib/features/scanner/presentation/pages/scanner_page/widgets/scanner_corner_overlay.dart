import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import 'scanner_corner_painter.dart';

/// The searching/detected corner-bracket frame
/// (`SpendLens.dc.html`'s "Scanner searching"/"Scanner detected" artboards):
/// pulsing white corners while searching, solid teal/accent corners once a
/// receipt is detected. Owns the pulse [AnimationController] and disposes
/// it — see `scanner_pulse_controller_mixin.dart`.
class ScannerCornerOverlay extends StatefulWidget {
  final bool isDetected;
  final Rect? bounds;

  const ScannerCornerOverlay({
    super.key,
    required this.isDetected,
    required this.bounds,
  });

  @override
  State<ScannerCornerOverlay> createState() => _ScannerCornerOverlayState();
}

class _ScannerCornerOverlayState extends State<ScannerCornerOverlay>
    with SingleTickerProviderStateMixin {
  /// design_spendlens.md §8 / `SpendLens.dc.html` `slPulse` — 2.2s, the ONLY
  /// thing this milestone keeps from the design's animation set (the
  /// TIMING chain that drove state transitions is banned; the animation
  /// DURATIONS are presentation and are kept exactly).
  static const _pulseDuration = Duration(milliseconds: 2200);

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: _pulseDuration,
    );
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant ScannerCornerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDetected != widget.isDetected) _syncPulse();
  }

  /// The pulse plays ONLY while searching (not detected) — bounded to this
  /// widget's own lifetime and gated on the state that actually needs it,
  /// never a bare unconditional `repeat()` (chronic bug
  /// `perpetual-decorative-animation-above-router-means-no-route-is-ever-idle`).
  /// `detected` uses a solid, non-animated outline per the design (its
  /// `corners()` call passes `animate: false`).
  void _syncPulse() {
    if (widget.isDetected) {
      _pulseController.stop();
    } else {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          final opacity = widget.isDetected
              ? 1.0
              : 0.55 + (_pulseController.value * 0.45);

          return CustomPaint(
            painter: ScannerCornerPainter(
              color: widget.isDetected ? scheme.accent : AppColors.white.value,
              opacity: opacity,
              strokeWidth: widget.isDetected ? 3.5 : 3.0,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

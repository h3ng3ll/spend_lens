import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';

/// Paints the design's background: the flat `--bg` fill plus the two radial
/// `--glow` layers (`SpendLens Prototype.dc.html` line 23 —
/// `background-color:var(--bg);background-image:var(--glow)`).
///
/// The design's glow is stated as two CSS radial gradients:
///
/// ```css
/// radial-gradient(80% 50% at 20% 0%,   rgba(139,92,246,.28), transparent 60%)
/// radial-gradient(60% 40% at 100% 100%, rgba(34,211,238,.16), transparent 60%)
/// ```
///
/// Each maps to one [RadialGradient]: `at X% Y%` is the [Alignment] centre
/// (CSS 0–100% over the box → Flutter −1..1), `80% 50%` is the ellipse's
/// half-extent as a fraction of the box, and `transparent 60%` is the stop
/// where the hue has fully faded. `radius` is expressed against the box's
/// SHORTER side by Flutter, so each layer is drawn in its own
/// [SizedBox.expand]-ed [DecoratedBox] and stacked, rather than trying to
/// force two differently-proportioned ellipses into one gradient.
///
/// Wraps rather than replaces a `Scaffold`: the caller keeps its own
/// `Scaffold`, sets `backgroundColor: AppColors.transparent`, and puts this
/// widget behind it so the glow shows through the translucent `--card`
/// surfaces (`AppSectionCard`) the way the design intends.
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final glow = scheme.glowLayers;

    return DecoratedBox(
      decoration: BoxDecoration(color: scheme.bg),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, -1.0),
                  radius: 1.1,
                  colors: [glow.first, glow.first.withValues(alpha: 0.0)],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  radius: 0.9,
                  colors: [glow.last, glow.last.withValues(alpha: 0.0)],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

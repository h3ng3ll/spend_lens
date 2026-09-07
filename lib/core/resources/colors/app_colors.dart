import 'package:flutter/material.dart';

/// Raw named palette values.
///
/// M1 seeds a minimal, correct skeleton (neutrals + one accent pair) so the
/// app boots and themes. M2 replaces this with the full SpendLens token set
/// from design_spendlens.md §4.1 — the 12 category hues, the trend pair, the
/// gradient stops and the translucent tokens (those stay `withValues(alpha:)`
/// expressions in `AppColorScheme`, never enum entries, per §4.1).
enum AppColors {
  black(Color(0xFF000000)),
  white(Color(0xFFFFFFFF)),
  transparent(Color(0x00000000)),

  // Neutral / surface pairs (dark default; light() supplies the light pair).
  neutral900(Color(0xFF0B0B10)),
  neutral800(Color(0xFF15151C)),
  neutral100(Color(0xFFF3F4F6)),
  neutralWhite(Color(0xFFFDFDFD)),

  // Accent pair — placeholder until M2 ports the design's exact hex pair.
  accent(Color(0xFFC4B5FD)),
  accentDark(Color(0xFF5B3FC4)),

  // Warn pair — destructive / delete-all token (design_spendlens.md §7).
  warn(Color(0xFFF87171)),
  warnDark(Color(0xFFB91C1C));

  final Color value;

  const AppColors(this.value);
}

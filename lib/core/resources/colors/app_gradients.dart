import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Named gradients (design_spendlens.md §4.2/§4.3).
///
/// The design's two prototype gradient variants are normalized to ONE
/// `accentGradient` (135°, `#C4B5FD → #8EE3F5`). `#A78BFA`/`#67E8F9` survive
/// only as the Food/Transport category hues in `AppColors`, where they
/// genuinely are category colours rather than brand gradient stops.
abstract class AppGradients {
  static LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accentDark.value,
      AppColors.accent2Dark.value,
    ],
  );
}

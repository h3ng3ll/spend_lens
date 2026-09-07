import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Named gradients.
///
/// M1 keeps one placeholder gradient so `AppFab` compiles. M2 replaces this
/// with the design's single normalized `accentGradient` (135°,
/// `#C4B5FD → #8EE3F5`, design_spendlens.md §4.2).
abstract class AppGradients {
  static LinearGradient bluePurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accent.value,
      AppColors.accentDark.value,
    ],
  );
}

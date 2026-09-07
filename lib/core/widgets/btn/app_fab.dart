import 'package:flutter/material.dart';

import '../../resources/colors/app_colors.dart';
import '../../resources/colors/app_gradients.dart';

/// The single standard floating action button for the app.
///
/// Encapsulates the FAB look (gradient fill, circular shape, foreground
/// tint) in one place so the styling is never repeated across screens.
/// Reuses existing app resources for colors/gradients.
class AppFab extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const AppFab({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed?.call,
      backgroundColor: AppColors.transparent.value,
      foregroundColor: AppColors.white.value,
      elevation: 0.0,
      highlightElevation: 0.0,
      shape: const CircleBorder(),
      child: Ink(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.bluePurple,
        ),
        child: Container(
          alignment: Alignment.center,
          width: 56.0,
          height: 56.0,
          child: child,
        ),
      ),
    );
  }
}

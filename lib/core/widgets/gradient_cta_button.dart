import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';

/// The shared bottom gradient pill CTA (design_spendlens.md's manual-entry
/// artboards — Cash-expense's Save, New category's Create, New store's
/// Create store all share this exact 56dp gradient pill).
///
/// [enabled] false renders a dimmed, non-interactive variant using
/// `scheme.fieldDim` — the app's shared disabled-button convention (also
/// used by New category's Create button per its own artboard binding,
/// `createCatBtnStyle`).
class GradientCtaButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const GradientCtaButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AppContainer(
        height: 56.0,
        color: enabled ? null : scheme.fieldDim,
        gradient: enabled ? scheme.accentGradient : null,
        borderRadius: BorderRadius.circular(16.0),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textTheme.headline17.copyWith(
            color: enabled ? scheme.onAccent : scheme.dim,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

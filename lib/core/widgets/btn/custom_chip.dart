import 'package:flutter/material.dart';

import '../../resources/colors/app_color_scheme.dart';
import '../../resources/colors/app_gradients.dart';
import '../app_container.dart';

/// A pill chip: the accent gradient when [selected], the semantic field
/// fill when not.
///
/// The unselected/disabled fills are read from [AppColorScheme] rather than
/// a raw palette constant. They were previously hardcoded to
/// `AppColors.white`, which assumed a light surface — on this dark-only app
/// that painted a white pill under near-white `scheme.ink` text, leaving
/// unselected chip labels invisible. The design specifies
/// `background:var(--field)` for the unselected state.
class CustomChip extends StatelessWidget {
  final bool selected;
  final Widget label;
  final VoidCallback? onTap;
  final double? width;

  const CustomChip({
    super.key,
    required this.selected,
    required this.label,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final borderRadius = BorderRadius.circular(
      25.0,
    );
    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: AppContainer(
        width: width,
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        borderRadius: borderRadius,
        color: onTap == null
            // is inactive
            ? scheme.field.withValues(alpha: 0.3)
            : selected
            ? null
            : scheme.field,
        gradient: !selected ? null : AppGradients.accentGradient,
        child: label,
      ),
    );
  }
}

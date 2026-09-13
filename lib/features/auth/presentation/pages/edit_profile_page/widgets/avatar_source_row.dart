import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// One tappable row inside [AvatarSourceSheet].
class AvatarSourceRow extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  /// Destructive rows render in `scheme.warn` — the token the Sign-out row
  /// already uses, never a raw colour.
  final bool isDestructive;

  const AvatarSourceRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final color = isDestructive ? scheme.warn : scheme.ink;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: HorizontalPadding(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            spacing: 14.0,
            children: [
              AppSvgIcon(asset: icon, color: color, size: 20.0),
              Text(label, style: textTheme.body17.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

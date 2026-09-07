import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The single SVG-icon primitive for the app.
///
/// Every screen/widget that needs a themed vector icon uses this instead of
/// `Icon(Icons.*)` (banned project-wide, per CLAUDE.md's hard bans list) or a
/// bare `SvgPicture.asset` call — centralizing the `colorFilter` wiring means
/// every icon is theme-tintable through [AppColorScheme] by construction.
class AppSvgIcon extends StatelessWidget {
  final String asset;
  final double size;
  final Color color;

  const AppSvgIcon({
    super.key,
    required this.asset,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

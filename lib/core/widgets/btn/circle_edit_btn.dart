import 'package:flutter/material.dart';

import '../../resources/app_icons.dart';
import '../../resources/colors/app_color_scheme.dart';
import '../app_container.dart';
import '../app_svg_icon.dart';

/// The circular "edit" button that mirrors [CircleBackBtn] on the opposite
/// side of a header row: the same 40×40 circle, `--card` fill and `--line`
/// hairline border, carrying the pencil glyph.
///
/// Sized to match [CircleBackBtn] exactly, because it REPLACES the 40px
/// spacer those headers use for symmetry — so the centred title stays centred
/// rather than shifting when the button appears.
class CircleEditBtn extends StatelessWidget {
  final VoidCallback onTap;

  const CircleEditBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        width: 40.0,
        height: 40.0,
        color: scheme.card,
        border: Border.all(color: scheme.line, width: 1.0),
        shape: BoxShape.circle,
        alignment: Alignment.center,
        child: AppSvgIcon(
          asset: AppIcons.edit,
          color: scheme.ink,
          size: 18.0,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../resources/colors/app_color_scheme.dart';
import '../app_container.dart';

/// The circular "close/back" button used on every top-level pushed screen's
/// header (design_spendlens.md — verified across the Store Detail, Profile,
/// Categories, New Category, New Store and Choose Store artboards): a 40×40
/// circle, `--card` fill, `--line` hairline border, a hand-drawn chevron
/// (two rotated hairlines), never an SVG asset for this exact glyph.
///
/// Distinct from [CustomBackBtn] (frosted white-overlay style, used over a
/// photo/gradient header) — this is the card-surface variant used on plain
/// `--bg` screens.
class CircleBackBtn extends StatelessWidget {
  final VoidCallback onTap;

  const CircleBackBtn({super.key, required this.onTap});

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
        child: Transform.rotate(
          angle: 0.785398,
          child: AppContainer(
            width: 9.0,
            height: 9.0,
            margin: const EdgeInsets.only(right: 2.0),
            border: Border(
              left: BorderSide(color: scheme.ink, width: 2.0),
              bottom: BorderSide(color: scheme.ink, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}

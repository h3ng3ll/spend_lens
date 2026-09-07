import 'package:flutter/material.dart';

import '../resources/text/app_text_theme.dart';
import 'app_container.dart';

/// The rounded initial-letter tile used by Home's recent list, History rows
/// and the Stores list (design_spendlens.md §10).
///
/// Sized with `width`/`height` as a fixed VISUAL box — deliberately, since a
/// circular/rounded avatar-style tile is expected to stay geometrically
/// square regardless of text scale. This is NOT the row-height chronic bug
/// site (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`):
/// the tile itself never constrains the ROW's height — every row that places
/// this tile lays it out inside a `Row` with `CrossAxisAlignment.center` and
/// an unconstrained (min-content) height, so a larger textScaleFactor grows
/// the row around this tile rather than clipping it.
class InitialTile extends StatelessWidget {
  final String initial;
  final Color background;
  final Color foreground;
  final double size;
  final double borderRadius;

  const InitialTile({
    super.key,
    required this.initial,
    required this.background,
    required this.foreground,
    this.size = 36.0,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      width: size,
      height: size,
      color: background,
      borderRadius: BorderRadius.circular(borderRadius),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: textTheme.headline17Semi.copyWith(color: foreground),
      ),
    );
  }
}

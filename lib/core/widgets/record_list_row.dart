import 'package:flutter/material.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';
import 'initial_tile.dart';

/// A single tappable record row (Home's Recent list, History, Stores'
/// "Products bought here") — one initial tile, a title + meta line, and a
/// trailing amount.
///
/// CHRONIC BUG GUARD
/// (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`):
/// this row has **no fixed height** anywhere. It is a `Row` with
/// `CrossAxisAlignment.center`, wrapped in vertical `Padding` — the row's
/// total height is whatever its tallest child needs, so it grows correctly
/// under a larger `textScaleFactor` instead of clipping. Only [InitialTile]
/// is a fixed geometric box (deliberately — see its own doc comment), and it
/// never constrains this row's height.
class RecordListRow extends StatelessWidget {
  final String initial;
  final Color tileBackground;
  final Color tileForeground;
  final String title;
  final String meta;
  final String amountText;
  final VoidCallback? onTap;
  final bool showBottomDivider;

  /// Replaces the [InitialTile] when the record has a real image of its own —
  /// today, a store with a logo.
  ///
  /// Optional so every existing caller keeps the initial tile unchanged, and
  /// so [initial] stays the fallback rather than becoming dead: a store
  /// without a logo still renders its letter through the default path.
  ///
  /// It must keep the tile's 36dp box; see [InitialTile] on why that fixed
  /// square is not the row-height chronic bug.
  final Widget? leading;

  const RecordListRow({
    super.key,
    required this.initial,
    required this.tileBackground,
    required this.tileForeground,
    required this.title,
    required this.meta,
    required this.amountText,
    this.onTap,
    this.showBottomDivider = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12.0,
        children: [
          leading ??
              InitialTile(
                initial: initial,
                background: tileBackground,
                foreground: tileForeground,
              ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headline17.copyWith(color: scheme.ink),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  meta,
                  style: textTheme.footnote13.copyWith(color: scheme.ter),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            amountText,
            style: textTheme.headline17.copyWith(
              color: scheme.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );

    final content = AppContainer(
      border: showBottomDivider
          ? Border(bottom: BorderSide(color: scheme.field, width: 0.5))
          : null,
      clipBehavior: Clip.none,
      child: row,
    );

    if (onTap == null) return content;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}

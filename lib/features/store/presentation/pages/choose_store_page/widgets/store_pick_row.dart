import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/initial_tile.dart';
import '../../../../domain/models/store/store.dart';
import 'store_type_label_x.dart';

/// A single row in the Choose-store picker (design_spendlens.md's
/// Choose-store artboard — the `st` loop item): initial tile, name + store
/// type meta line, tapping it picks the store.
class StorePickRow extends StatelessWidget {
  final Store store;
  final bool isSelected;
  final VoidCallback onTap;

  const StorePickRow({
    super.key,
    required this.store,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    // CHRONIC BUG GUARD
    // (`sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`):
    // no fixed `height:` on this row — it sizes to its two-line text
    // content via vertical `Padding`, so a larger textScaleFactor grows the
    // row instead of clipping the store name/type text.
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        border: Border(bottom: BorderSide(color: scheme.field, width: 0.5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.0,
            children: [
              InitialTile(
                initial: store.name.isEmpty ? '?' : store.name[0].toUpperCase(),
                background: scheme.accentTint,
                foreground: scheme.accent,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: textTheme.body17.copyWith(
                        color: scheme.ink,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      store.type.label(lo),
                      style: textTheme.footnote13.copyWith(color: scheme.ter),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                AppSvgIcon(asset: AppIcons.check, color: scheme.accent, size: 18.0),
            ],
          ),
        ),
      ),
    );
  }
}

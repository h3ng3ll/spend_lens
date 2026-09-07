import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// The Cash-expense "Store" row (design_spendlens.md's Cash-expense
/// artboard): either "No store" or the selected store's name, a clear (×)
/// button shown ONLY while a store is selected, and a chevron. Tapping the
/// row (not the ×) opens the store picker; tapping × clears the selection —
/// two distinct tap targets, so the × sits in its own `GestureDetector`
/// nested inside the row's.
class CashStoreRow extends StatelessWidget {
  final String? storeName;
  final String noStoreLabel;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const CashStoreRow({
    super.key,
    required this.storeName,
    required this.noStoreLabel,
    required this.onTap,
    required this.onClear,
  });

  bool get _hasStore => storeName != null;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        height: 48.0,
        color: scheme.field,
        borderRadius: BorderRadius.circular(14.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10.0,
          children: [
            Expanded(
              child: Text(
                storeName ?? noStoreLabel,
                style: textTheme.body17.copyWith(
                  color: _hasStore ? scheme.ink : scheme.ter,
                ),
              ),
            ),
            if (_hasStore)
              GestureDetector(
                onTap: onClear,
                child: AppContainer(
                  width: 24.0,
                  height: 24.0,
                  color: scheme.field2,
                  shape: BoxShape.circle,
                  alignment: Alignment.center,
                  child: AppSvgIcon(
                    asset: AppIcons.close,
                    color: scheme.sec,
                    size: 12.0,
                  ),
                ),
              ),
            AppSvgIcon(
              asset: AppIcons.chevronRight,
              color: scheme.ter,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}

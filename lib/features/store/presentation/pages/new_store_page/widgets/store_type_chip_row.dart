import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/btn/custom_chip.dart';
import '../../../../domain/models/store/e_store_type.dart';
import '../../choose_store_page/widgets/store_type_label_x.dart';

/// The New-store "Type" chip row (design_spendlens.md's New-store artboard):
/// a single-select `Wrap` of [EStoreType] chips using [CustomChip] — never a
/// grid, per A9's `childAspectRatio` ban (irrelevant here regardless, since
/// a `Wrap` is used, not a grid).
class StoreTypeChipRow extends StatelessWidget {
  final EStoreType selected;
  final ValueChanged<EStoreType> onSelected;

  const StoreTypeChipRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final type in EStoreType.values)
          CustomChip(
            selected: type == selected,
            onTap: () => onSelected(type),
            label: Text(
              type.label(lo),
              style: textTheme.subhead15.copyWith(
                color: type == selected ? scheme.onAccent : scheme.ink,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/btn/custom_chip.dart';
import '../../../../domain/models/product/e_unit.dart';
import '../../../../domain/models/product/e_unit_label_x.dart';

/// The unit-of-measure chip row — piece / kg / L.
///
/// A chip row rather than the receipt editor's tap-to-cycle control: on a
/// creation form the user has no existing value to correct, so all options
/// should be visible at once instead of requiring up to two taps to discover
/// the third.
class ProductUnitChipRow extends StatelessWidget {
  final EUnit selected;
  final ValueChanged<EUnit> onSelected;

  const ProductUnitChipRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        for (final unit in EUnit.values)
          Expanded(
            child: CustomChip(
              selected: unit == selected,
              label: Text(
                unit.shortLabel,
                style: textTheme.subhead15.copyWith(
                  color: unit == selected ? scheme.onAccent : scheme.sec,
                ),
              ),
              onTap: () => onSelected(unit),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// One editable item row on the Edit-receipt screen
/// (`SpendLens Prototype.dc.html` line 564): name field + remove button,
/// qty/price fields, and the original OCR line for reference.
///
/// `db:textfield-loses-focus-on-keystroke` — every field here uses a
/// PERSISTENT [TextEditingController] the parent page owns per item id
/// (never `key: ValueKey` + `initialValue:`).
class EditItemRow extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final String qtyLabel;
  final String priceLabel;
  final String? rawLine;
  final VoidCallback onRemove;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onQuantityChanged;

  /// Tapping the qty/unit label cycles the item's unit of measure.
  final VoidCallback onCycleUnit;
  final ValueChanged<String> onPriceChanged;

  /// Opens the product picker so the user can override the automatic match.
  final VoidCallback onPickProduct;

  /// Whether this line is already pinned to a product the user chose.
  final bool hasPickedProduct;

  const EditItemRow({
    super.key,
    required this.nameController,
    required this.quantityController,
    required this.priceController,
    required this.qtyLabel,
    required this.priceLabel,
    this.rawLine,
    required this.onRemove,
    required this.onNameChanged,
    required this.onQuantityChanged,
    required this.onCycleUnit,
    required this.onPriceChanged,
    required this.onPickProduct,
    required this.hasPickedProduct,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppContainer(
      border: Border(bottom: BorderSide(color: scheme.field, width: 0.5)),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: nameController,
                  fillColor: scheme.field,
                  filled: true,
                  style: textTheme.body17.copyWith(color: scheme.ink),
                  onChanged: onNameChanged,
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: AppContainer(
                  width: 32.0,
                  height: 32.0,
                  shape: BoxShape.circle,
                  color: scheme.field,
                  alignment: Alignment.center,
                  child: AppSvgIcon(
                    asset: AppIcons.close,
                    color: scheme.sec,
                    size: 14.0,
                  ),
                ),
              ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ConstrainedBox(
                  // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
                  // textScaleFactor — hosts the qty label + an editable
                  // text field, so MIN-HEIGHT only (the 32×32 icon-only
                  // remove button above is the correct FIXED-size case).
                  constraints: const BoxConstraints(minHeight: 40.0),
                  child: AppContainer(
                    color: scheme.field,
                    borderRadius: BorderRadius.circular(12.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    child: Row(
                      spacing: 6.0,
                      children: [
                        // The label is the unit CONTROL, not decoration:
                        // OCR reads `kg` as `kq`/`ka` often enough that the
                        // parsed unit is a guess the user must be able to
                        // correct — and on a weighed line the quantity IS
                        // the weight, so a wrong unit mislabels the number.
                        GestureDetector(
                          onTap: onCycleUnit,
                          child: Text(
                            qtyLabel,
                            style: textTheme.subhead15.copyWith(
                              color: scheme.accent,
                              decoration: TextDecoration.underline,
                              decorationColor: scheme.accent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: quantityController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                            textAlign: TextAlign.right,
                            style: textTheme.subhead15.copyWith(
                              color: scheme.ink,
                            ),
                            onChanged: onQuantityChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
                  // textScaleFactor — hosts the price label + an editable
                  // text field, so MIN-HEIGHT only.
                  constraints: const BoxConstraints(minHeight: 40.0),
                  child: AppContainer(
                    color: scheme.field,
                    borderRadius: BorderRadius.circular(12.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    child: Row(
                      spacing: 6.0,
                      children: [
                        Text(
                          priceLabel,
                          style: textTheme.subhead15.copyWith(
                            color: scheme.ter,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: priceController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                            textAlign: TextAlign.right,
                            style: textTheme.subhead15.copyWith(
                              color: scheme.ink,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                            onChanged: onPriceChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (rawLine != null && rawLine!.isNotEmpty)
            Text(
              rawLine!,
              style: textTheme.footnote13.copyWith(color: scheme.ter),
            ),
          // The override affordance. Automatic matching resolves by name
          // similarity and can land on the wrong product or mint a
          // duplicate, and until now there was no way to say so.
          GestureDetector(
            onTap: onPickProduct,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6.0,
              children: [
                AppSvgIcon(
                  asset: AppIcons.search,
                  color: scheme.accent,
                  size: 14.0,
                ),
                Text(
                  hasPickedProduct ? lo.editProductTitle : lo.chooseProduct,
                  style: textTheme.footnote13.copyWith(
                    color: scheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

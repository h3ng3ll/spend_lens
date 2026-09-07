import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The Cash-expense amount field (design_spendlens.md's Cash-expense
/// artboard): a large tabular-figure numeric input with a trailing currency
/// code, filled `--field` surface, no border. `inputMode="decimal"` in the
/// design maps to [TextInputType.numberWithOptions] with `decimal: true`;
/// [FilteringTextInputFormatter] restricts entry to a single optional
/// decimal point so the field can never hold an unparsable value.
class CashAmountField extends StatelessWidget {
  final TextEditingController controller;
  final String currencyCode;

  const CashAmountField({
    super.key,
    required this.controller,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      height: 64.0,
      color: scheme.field,
      borderRadius: BorderRadius.circular(14.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8.0,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: textTheme.amountInput32.copyWith(color: scheme.ink),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Text(
            currencyCode,
            style: textTheme.headline17.copyWith(color: scheme.sec),
          ),
        ],
      ),
    );
  }
}

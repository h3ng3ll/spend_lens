import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../product/domain/models/product/e_unit.dart';
import '../../../../../product/domain/models/product/e_unit_label_x.dart';

/// One Review line-item row, VIEW mode (`SpendLens Prototype.dc.html` line
/// 513/499): name + low-confidence flag on the left, quantity/unit-price
/// meta line, line total on the right.
///
/// ⛔ `sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor` —
/// this row carries user-facing, potentially multi-line text (a long
/// product name at large `textScaleFactor`), so it uses
/// `ConstrainedBox(minHeight:)` rather than a fixed `height:`. Per-site
/// terminal state: MIN-HEIGHT (text-bearing row, grows with text scale).
class ReviewItemRow extends StatelessWidget {
  static const _minRowHeight = 56.0;

  final String name;
  final double quantity;
  final EUnit unit;
  final double? unitPrice;
  final double lineTotal;
  final bool isLowConfidence;
  final bool isManuallyAdded;
  final bool showBottomBorder;
  final String addedManuallyLabel;
  final VoidCallback onTap;

  const ReviewItemRow({
    super.key,
    required this.name,
    required this.quantity,
    required this.unit,
    this.unitPrice,
    required this.lineTotal,
    required this.isLowConfidence,
    required this.isManuallyAdded,
    required this.showBottomBorder,
    required this.addedManuallyLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    final metaText = unit == EUnit.piece
        ? '${quantity.toStringAsFixed(quantity == quantity.roundToDouble() ? 0 : 1)} × ${(unitPrice ?? lineTotal).toStringAsFixed(2)}'
        : '${quantity.toStringAsFixed(2)} ${unit.shortLabel} @ ${(unitPrice ?? 0.0).toStringAsFixed(2)}';

    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _minRowHeight),
        child: AppContainer(
          border: showBottomBorder
              ? Border(bottom: BorderSide(color: scheme.field, width: 0.5))
              : null,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.0,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8.0,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: textTheme.headline17.copyWith(
                              color: scheme.ink,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLowConfidence)
                          AppContainer(
                            width: 6.0,
                            height: 6.0,
                            shape: BoxShape.circle,
                            color: scheme.warn,
                          ),
                      ],
                    ),
                    Text(
                      isManuallyAdded ? addedManuallyLabel : metaText,
                      style: textTheme.footnote13.copyWith(
                        color: isLowConfidence ? scheme.warn : scheme.ter,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                lineTotal.toStringAsFixed(2),
                style: textTheme.headline17.copyWith(
                  color: scheme.ink,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

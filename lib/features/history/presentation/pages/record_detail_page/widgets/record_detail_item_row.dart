import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../product/domain/models/product/e_unit.dart';
import '../../../../../product/domain/models/product/e_unit_label_x.dart';

/// One line item on Record Detail's Items card (design_spendlens.md — the
/// Record detail artboard's `dItems` rows): name on the left over a
/// quantity × unit-price meta line, line total right-aligned, hairline
/// separator beneath every row but the last.
///
/// A READ-ONLY sibling of `ReviewItemRow` rather than a reuse of it: that
/// widget lives under `review_page/widgets/` (page-local by A2), and its
/// `onTap` is non-nullable because tapping a Review row opens the inline
/// editor. This screen shows a SAVED receipt, where a row is not editable —
/// editing goes through the header's Edit action to `EditReceiptPage` — so
/// passing a no-op callback would ship a tap target that silently does
/// nothing.
///
/// ⛔ `sig:developer-derived-fixed-dp-cell-height-ignores-textScaleFactor` —
/// this row carries user-facing, potentially multi-line text (a long
/// product name at large `textScaleFactor`), so it uses
/// `ConstrainedBox(minHeight:)` rather than a fixed `height:`. Per-site
/// terminal state: MIN-HEIGHT (text-bearing row, grows with text scale).
class RecordDetailItemRow extends StatelessWidget {
  static const _minRowHeight = 52.0;

  final String name;
  final double quantity;
  final EUnit unit;
  final double? unitPrice;
  final double lineTotal;
  final bool showBottomBorder;

  const RecordDetailItemRow({
    super.key,
    required this.name,
    required this.quantity,
    required this.unit,
    this.unitPrice,
    required this.lineTotal,
    required this.showBottomBorder,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    // Matches the design's `1 × 22.90` meta line for piece-priced goods,
    // and a weighed line's `1.20 kg @ 84.50` for the rest.
    final metaText = unit == EUnit.piece
        ? '${quantity.toStringAsFixed(quantity == quantity.roundToDouble() ? 0 : 1)} × ${(unitPrice ?? lineTotal).toStringAsFixed(2)}'
        : '${quantity.toStringAsFixed(2)} ${unit.shortLabel} @ ${(unitPrice ?? 0.0).toStringAsFixed(2)}';

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minRowHeight),
      child: AppContainer(
        border: showBottomBorder
            ? Border(bottom: BorderSide(color: scheme.field, width: 0.5))
            : null,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headline17.copyWith(
                      color: scheme.ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    metaText,
                    style: textTheme.footnote13.copyWith(color: scheme.ter),
                  ),
                ],
              ),
            ),
            Text(
              lineTotal.toStringAsFixed(2),
              style: textTheme.headline17.copyWith(
                color: scheme.ink,
                fontWeight: FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

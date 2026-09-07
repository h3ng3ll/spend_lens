import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// Review's subtotal/discount/total summary card
/// (`SpendLens Prototype.dc.html` line 517) plus the reconciliation status
/// line — WARNS on a mismatch but never blocks Save (spec §45).
class ReviewTotalsCard extends StatelessWidget {
  final String subtotalLabel;
  final double subtotal;
  final String discountLabel;
  final double discount;
  final String totalLabel;
  final double total;
  final String currencyCode;
  final bool isReconciled;
  final String matchLabel;
  final String mismatchLabel;

  const ReviewTotalsCard({
    super.key,
    required this.subtotalLabel,
    required this.subtotal,
    required this.discountLabel,
    required this.discount,
    required this.totalLabel,
    required this.total,
    required this.currencyCode,
    required this.isReconciled,
    required this.matchLabel,
    required this.mismatchLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final statusColor = isReconciled ? scheme.accent : scheme.warn;

    return AppContainer(
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtotalLabel,
                style: textTheme.subhead15.copyWith(color: scheme.sec),
              ),
              Text(
                subtotal.toStringAsFixed(2),
                style: textTheme.subhead15.copyWith(
                  color: scheme.sec,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                discountLabel,
                style: textTheme.subhead15.copyWith(color: scheme.sec),
              ),
              Text(
                discount.toStringAsFixed(2),
                style: textTheme.subhead15.copyWith(
                  color: scheme.sec,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          AppContainer(
            border: Border(top: BorderSide(color: scheme.field, width: 0.5)),
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalLabel,
                  style: textTheme.headline17Semi.copyWith(color: scheme.ink),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  spacing: 6.0,
                  children: [
                    Text(
                      total.toStringAsFixed(2),
                      style: textTheme.statValue20.copyWith(
                        color: scheme.ink,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      currencyCode,
                      style: textTheme.subhead15.copyWith(color: scheme.sec),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6.0,
            children: [
              AppContainer(
                width: 6.0,
                height: 6.0,
                shape: BoxShape.circle,
                color: statusColor,
              ),
              Flexible(
                child: Text(
                  isReconciled ? matchLabel : mismatchLabel,
                  style: textTheme.footnote13.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

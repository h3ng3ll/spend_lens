import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';

/// The Cash vs Receipts split bar (`SpendLens Prototype.dc.html`'s
/// `cashBarStyle` row) — a single horizontal bar split into a cash segment
/// and a receipts segment, plus a legend line underneath.
///
/// M5 has no receipt-sourced expenses yet (receipts require scanning,
/// M7/M8), so `cashSharePercent == 100` is the CORRECT, expected value here
/// — never faked receipt data to make the split look less one-sided
/// (design_spendlens.md Analytics design requirements).
class AnalyticsCashReceiptSplitCard extends StatelessWidget {
  /// 0–100.
  final int cashSharePercent;

  const AnalyticsCashReceiptSplitCard({
    super.key,
    required this.cashSharePercent,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final cashPercent = cashSharePercent.clamp(0, 100);
    final receiptPercent = 100 - cashPercent;

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.0,
        children: [
          SectionLabel(text: lo.cashVsReceipts),
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              return AppContainer(
                width: trackWidth,
                height: 10.0,
                color: scheme.field,
                borderRadius: BorderRadius.circular(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppContainer(
                      width: trackWidth * (cashPercent / 100.0),
                      gradient: scheme.accentGradient,
                    ),
                    Expanded(child: AppContainer(color: scheme.ter)),
                  ],
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$receiptPercent% ',
                      style: textTheme.footnote13.copyWith(
                        color: scheme.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: lo.receiptsLower,
                      style: textTheme.footnote13.copyWith(color: scheme.sec),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$cashPercent% ',
                      style: textTheme.footnote13.copyWith(
                        color: scheme.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: lo.cashLower,
                      style: textTheme.footnote13.copyWith(color: scheme.sec),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

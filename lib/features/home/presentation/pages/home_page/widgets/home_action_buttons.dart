import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// Home's height-56 "Scan Receipt" (gradient) and height-48
/// "Add Cash Expense" (translucent) buttons, stacked
/// (design_spendlens.md — Home artboard's `goScan`/`openCash` block).
class HomeActionButtons extends StatelessWidget {
  final String scanIconAsset;
  final VoidCallback onScanReceipt;
  final VoidCallback onAddCashExpense;

  static const double _scanButtonHeight = 56.0;
  static const double _cashButtonHeight = 48.0;

  const HomeActionButtons({
    super.key,
    required this.scanIconAsset,
    required this.onScanReceipt,
    required this.onAddCashExpense,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.0,
      children: [
        GestureDetector(
          onTap: onScanReceipt,
          child: SizedBox(
            width: double.infinity,
            child: AppContainer(
              height: _scanButtonHeight,
              gradient: scheme.accentGradient,
              borderRadius: BorderRadius.circular(16.0),
              alignment: Alignment.center,
              boxShadow: [
                BoxShadow(
                  color: scheme.accent.withValues(alpha: 0.35),
                  blurRadius: 28.0,
                  offset: const Offset(0.0, 8.0),
                ),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  AppSvgIcon(
                    asset: scanIconAsset,
                    color: scheme.onAccent,
                    size: 18.0,
                  ),
                  Text(
                    lo.scanReceipt,
                    style: textTheme.headline17.copyWith(
                      color: scheme.onAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onAddCashExpense,
          child: SizedBox(
            width: double.infinity,
            child: AppContainer(
              height: _cashButtonHeight,
              color: scheme.card,
              border: Border.all(color: scheme.line, width: 1.0),
              borderRadius: BorderRadius.circular(16.0),
              alignment: Alignment.center,
              child: Text(
                lo.addCash,
                style: textTheme.subhead15.copyWith(
                  color: scheme.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

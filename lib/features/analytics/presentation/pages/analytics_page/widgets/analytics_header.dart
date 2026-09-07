import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/services/ui_message_service.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// The Analytics screen title + "Export PDF" pill
/// (`SpendLens Prototype.dc.html` `data-screen-label="Analytics"`, the
/// `exportPdf` row).
///
/// A real PDF export is not in M5's scope (design_spendlens.md §10 — it is
/// not named in M5's deliverable list); tapping the pill shows an info toast
/// rather than inventing a working export or silently doing nothing
/// (recorded global bug: a stub handler that only echoes its own label is
/// indistinguishable from doing real work — this one is honest about being
/// unavailable, not a disguised no-op).
/// Unscaled base height for the export pill; multiplied by the text scaler
/// at build time so the label cannot clip (recorded bug
/// `developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`).
const double _baseExportChipHeight = 36.0;

class AnalyticsHeader extends StatelessWidget {
  const AnalyticsHeader({super.key});

  void _onExportPdf(BuildContext context) {
    UiMessageService.showInfo(
      AppLocalizations.of(context).pdfExportUnavailable,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);
    final pdfChipHeight = MediaQuery.textScalerOf(
      context,
    ).scale(_baseExportChipHeight);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lo.tabAnalytics,
          style: textTheme.screenTitle28.copyWith(color: scheme.ink),
        ),
        GestureDetector(
          onTap: () => _onExportPdf(context),
          child: AppContainer(
            height: pdfChipHeight,
            color: scheme.card,
            border: Border.all(color: scheme.line, width: 1.0),
            borderRadius: BorderRadius.circular(999.0),
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 12.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 7.0,
              children: [
                AppSvgIcon(
                  asset: AppIcons.pdf,
                  color: scheme.accent,
                  size: 16.0,
                ),
                Text(
                  lo.pdf,
                  style: textTheme.subhead15.copyWith(
                    color: scheme.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

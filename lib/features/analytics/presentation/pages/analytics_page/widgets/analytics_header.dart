import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// The Analytics screen title + "Export PDF" pill
/// (`SpendLens Prototype.dc.html` `data-screen-label="Analytics"`, the
/// `exportPdf` row).
///
/// The pill now performs a REAL export. It previously showed an
/// "arrives in a later update" toast — the design prototype's own
/// `exportPdf` is also only a toast, but a control that advertises an export
/// and delivers nothing is missing functionality, not a spec to reproduce.
///
/// The work itself is owned by `AnalyticsPage` (which holds the period,
/// currency and snapshot this widget has no access to) and runs on a
/// background isolate, so this stays a plain presentational pill.
/// Unscaled base height for the export pill; multiplied by the text scaler
/// at build time so the label cannot clip (recorded bug
/// `developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`).
const double _baseExportChipHeight = 36.0;

class AnalyticsHeader extends StatelessWidget {
  final VoidCallback onExportPdf;

  /// Dims the pill and drops its tap target while an export is in flight, so
  /// a second tap cannot start a concurrent render (each one spawns its own
  /// isolate and writes its own temp file).
  final bool isExporting;

  const AnalyticsHeader({
    super.key,
    required this.onExportPdf,
    this.isExporting = false,
  });

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
          onTap: isExporting ? null : onExportPdf,
          child: Opacity(
            opacity: isExporting ? 0.5 : 1.0,
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
        ),
      ],
    );
  }
}

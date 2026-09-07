import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// The period selector pill (`SpendLens Prototype.dc.html`'s `openPeriod`
/// row) — shows the currently-selected month/year; tapping it is the
/// caller's job (opens `PeriodSheet`, owned by `AnalyticsPage` since the
/// selection is UI-local state, not bloc state).
/// Unscaled base heights; multiplied by the text scaler at build time.
const double _basePillHeight = 40.0;
const double _baseIconBoxSize = 28.0;

class AnalyticsPeriodPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AnalyticsPeriodPill({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    // Scaled, never fixed: a 40dp pill clips `headline17Semi` at textScale 2.0
    // (recorded bug `developer-derived-fixed-dp-cell-height-ignores-
    // textScaleFactor`). The icon box scales with it so the pill stays round.
    final scaler = MediaQuery.textScalerOf(context);
    final pillHeight = scaler.scale(_basePillHeight);
    final iconBoxSize = scaler.scale(_baseIconBoxSize);

    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: AppContainer(
          height: pillHeight,
          color: scheme.card,
          border: Border.all(color: scheme.line, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
          padding: const EdgeInsets.fromLTRB(14.0, 0.0, 6.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              Text(
                label,
                style: textTheme.headline17Semi.copyWith(color: scheme.ink),
              ),
              AppContainer(
                width: iconBoxSize,
                height: iconBoxSize,
                color: scheme.field,
                borderRadius: BorderRadius.circular(8.0),
                child: Center(
                  child: AppSvgIcon(
                    asset: AppIcons.chevronDown,
                    color: scheme.accent,
                    size: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

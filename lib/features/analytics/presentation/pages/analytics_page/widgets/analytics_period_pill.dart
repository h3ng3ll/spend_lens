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

    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: AppContainer(
          height: 40.0,
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
                width: 28.0,
                height: 28.0,
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

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// One stat card in [StoreStatsRow] (design_spendlens.md's Stores artboard,
/// `hasStoreSel` branch's 3-column stat grid): label + a tabular-figure
/// value.
class StoreStatCard extends StatelessWidget {
  final String label;
  final String value;

  const StoreStatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(16.0),
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,
        children: [
          Text(
            label,
            style: textTheme.sectionLabel12.copyWith(color: scheme.ter),
          ),
          Text(
            value,
            style: textTheme.statValue20.copyWith(
              color: scheme.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

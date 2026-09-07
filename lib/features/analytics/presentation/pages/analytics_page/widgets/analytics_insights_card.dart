import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';

/// The Insights card (`SpendLens Prototype.dc.html`'s `insights` list).
///
/// M5 shows 0–2 SIMPLE, HONEST insights computed inline from the raw
/// expense list (e.g. "{category} represented {percent}% of your
/// spending", via the existing `insA1` ARB placeholder) — never the M6
/// deterministic (ARB key, params) insight-generator module
/// (design_spendlens.md §10). When nothing can be honestly computed (no
/// expenses in the period) the caller passes an empty list and this card
/// renders no body rows rather than a fabricated placeholder line.
class AnalyticsInsightsCard extends StatelessWidget {
  final List<String> insights;

  const AnalyticsInsightsCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,
        children: [
          SectionLabel(text: lo.insights),
          for (final insight in insights)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                insight,
                style: textTheme.body17.copyWith(
                  color: scheme.ink,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';

/// One small stat card in the Analytics 3-column row (Average / Purchases /
/// Cash) — `SpendLens Prototype.dc.html`'s repeated stat-card block.
///
/// Sizes to its own content (no fixed `height:`) — a hardcoded box would
/// clip at a larger textScaleFactor (recorded chronic bug: fixed-dp
/// row/tile height ignoring text scale).
class AnalyticsStatTile extends StatelessWidget {
  final String label;
  final String value;
  final String caption;

  const AnalyticsStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.sectionLabel12.copyWith(color: scheme.ter),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.statValue20.copyWith(
                color: scheme.ink,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.sectionLabel12.copyWith(color: scheme.ter),
          ),
        ],
      ),
    );
  }
}

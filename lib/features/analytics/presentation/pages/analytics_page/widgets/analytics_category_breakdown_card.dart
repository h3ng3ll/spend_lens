import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/utils/extensions/color_ext.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../../../category/domain/models/category/category_display_x.dart';
import '../analytics_category_breakdown_row.dart';
import 'analytics_category_row.dart';

/// The per-category breakdown card — SectionLabel + one [AnalyticsCategoryRow]
/// per category with spend in the selected period, sorted by amount
/// descending (`analyticsViewHelpers.categoryBreakdown`).
class AnalyticsCategoryBreakdownCard extends StatelessWidget {
  final List<AnalyticsCategoryBreakdownRow> rows;
  final String currencyCode;

  const AnalyticsCategoryBreakdownCard({
    super.key,
    required this.rows,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,
        children: [
          SectionLabel(text: lo.categories),
          for (final row in rows)
            AnalyticsCategoryRow(
              color: ColorExtension.fromHex(row.category.colorHex),
              name: row.category.displayName(lo),
              amountText: '${row.amount.round()} $currencyCode',
              share: row.sharePercent / 100.0,
            ),
        ],
      ),
    );
  }
}

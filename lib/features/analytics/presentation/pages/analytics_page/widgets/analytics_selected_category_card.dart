import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/record_list_row.dart';
import '../analytics_selected_category_entry.dart';

/// The selected-category drill-down card
/// (`SpendLens Prototype.dc.html`, the `selItems` block under the donut:
/// `selName · selAmount` + `selCount`, then one row per purchase).
///
/// Tapping a donut slice previously only recoloured the ring — the design's
/// list of that category's actual purchases had no Flutter counterpart at
/// all, which is a large part of why the screen showed totals without ever
/// saying what they were made of.
///
/// Rows reuse the shared [RecordListRow] (Home's Recent list, History,
/// Stores), so this card inherits its text-scale behaviour and needs no
/// fixed row height of its own.
class AnalyticsSelectedCategoryCard extends StatelessWidget {
  final String categoryName;
  final String amountText;
  final String currencyCode;
  final Color categoryColor;
  final List<AnalyticsSelectedCategoryEntry> entries;

  const AnalyticsSelectedCategoryCard({
    super.key,
    required this.categoryName,
    required this.amountText,
    required this.currencyCode,
    required this.categoryColor,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  lo
                      .analyticsCategoryTotal(
                        categoryName,
                        amountText,
                        currencyCode,
                      )
                      .toUpperCase(),
                  style: textTheme.sectionLabel12.copyWith(
                    color: scheme.ter,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                lo.purchaseCount(entries.length),
                style: textTheme.footnote13.copyWith(color: scheme.ter),
              ),
            ],
          ),
          for (var i = 0; i < entries.length; i++)
            RecordListRow(
              initial: entries[i].initial,
              tileBackground: categoryColor.withValues(alpha: 0.13),
              tileForeground: categoryColor,
              title: entries[i].title,
              meta: entries[i].meta,
              amountText: entries[i].amountText,
              showBottomDivider: i != entries.length - 1,
            ),
        ],
      ),
    );
  }
}

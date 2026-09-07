import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../utils/category_name_resolver.dart';
import '../../../utils/home_calculations.dart';
import 'home_category_row.dart';

/// Home's "Categories" card: the section label + "All" link, then up to
/// [kHomeTopCategoryCount] rows sorted by this-month spend descending
/// (design_spendlens.md — Home artboard's category card).
class HomeCategoriesCard extends StatelessWidget {
  final List<HomeCategorySpend> categories;
  final String Function(double amount) formatAmount;

  const HomeCategoriesCard({
    super.key,
    required this.categories,
    required this.formatAmount,
  });

  void _onTapAll(BuildContext context) => const AnalyticsPageRoute().go(context);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              SectionLabel(text: lo.categories),
              GestureDetector(
                onTap: () => _onTapAll(context),
                child: Text(
                  lo.all,
                  style: textTheme.footnote13.copyWith(
                    color: scheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          for (final spend in categories)
            HomeCategoryRow(
              name: resolveCategoryName(lo, spend.category),
              amountText: formatAmount(spend.amount),
              fraction: spend.fractionOfMax,
              barColor: resolveCategoryColor(spend.category),
            ),
        ],
      ),
    );
  }
}

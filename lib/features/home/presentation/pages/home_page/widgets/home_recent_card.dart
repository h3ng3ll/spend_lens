import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/record_list_row.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../utils/home_calculations.dart';

/// Home's "Recent" card: the section label + "See all" link, then up to
/// [kHomeRecentCount] most-recent expense rows
/// (design_spendlens.md — Home artboard's `recent` `sc-for` block).
class HomeRecentCard extends StatelessWidget {
  final List<HomeRecentEntry> entries;

  const HomeRecentCard({super.key, required this.entries});

  void _onTapSeeAll(BuildContext context) => const HistoryPageRoute().go(context);

  void _onTapRecord(BuildContext context, String recordId) =>
      RecordDetailPageRoute(recordId: recordId).push(context);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SectionLabel(text: lo.recent),
                GestureDetector(
                  onTap: () => _onTapSeeAll(context),
                  child: Text(
                    lo.seeAll,
                    style: textTheme.footnote13.copyWith(
                      color: scheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < entries.length; i++)
            RecordListRow(
              initial: entries[i].initial,
              tileBackground: entries[i].tileBackground,
              tileForeground: entries[i].tileForeground,
              title: entries[i].title,
              meta: entries[i].meta,
              amountText: entries[i].amountText,
              showBottomDivider: i != entries.length - 1,
              onTap: () => _onTapRecord(context, entries[i].expense.id),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/initial_tile.dart';
import 'record_detail_badge.dart';

/// Record Detail's main card (design_spendlens.md — Record detail
/// artboard): the initial tile + resolved name + date row, the large
/// tabular-figure amount + currency, and the type/category badges row.
///
/// Layout only (A6, Container Rule) — every value is resolved by the caller
/// (`RecordDetailPage`) and passed in.
class RecordDetailCard extends StatelessWidget {
  final String initial;
  final Color tileBackground;
  final Color tileForeground;
  final String name;
  final String dateText;
  final String amountText;
  final String currencyCode;
  final String typeLabel;
  final String categoryLabel;
  final Color categoryDotColor;

  const RecordDetailCard({
    super.key,
    required this.initial,
    required this.tileBackground,
    required this.tileForeground,
    required this.name,
    required this.dateText,
    required this.amountText,
    required this.currencyCode,
    required this.typeLabel,
    required this.categoryLabel,
    required this.categoryDotColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.0,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.0,
            children: [
              InitialTile(
                initial: initial,
                background: tileBackground,
                foreground: tileForeground,
                size: 44.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headline17Semi.copyWith(color: scheme.ink),
                    ),
                    Text(
                      dateText,
                      style: textTheme.subhead15.copyWith(color: scheme.sec),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: 8.0,
            children: [
              Text(
                amountText,
                style: textTheme.detailAmount40.copyWith(
                  color: scheme.ink,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                currencyCode,
                style: textTheme.subhead15.copyWith(
                  color: scheme.sec,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              RecordDetailBadge(label: typeLabel),
              RecordDetailBadge(label: categoryLabel, dotColor: categoryDotColor),
            ],
          ),
        ],
      ),
    );
  }
}

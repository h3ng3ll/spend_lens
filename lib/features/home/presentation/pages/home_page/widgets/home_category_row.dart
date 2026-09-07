import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// A single category row inside Home's Categories card: name + amount above
/// a slim progress bar (design_spendlens.md — Home artboard's `cats`
/// `sc-for` row).
class HomeCategoryRow extends StatelessWidget {
  final String name;
  final String amountText;
  final double fraction;
  final Color barColor;

  static const double _barHeight = 6.0;

  const HomeCategoryRow({
    super.key,
    required this.name,
    required this.amountText,
    required this.fraction,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: textTheme.body17.copyWith(color: scheme.ink),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                amountText,
                style: textTheme.body17.copyWith(
                  color: scheme.ink,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: AppContainer(
            height: _barHeight,
            color: scheme.field,
            borderRadius: BorderRadius.circular(_barHeight / 2),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fraction.clamp(0.0, 1.0),
              child: AppContainer(
                height: _barHeight,
                color: barColor,
                borderRadius: BorderRadius.circular(_barHeight / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

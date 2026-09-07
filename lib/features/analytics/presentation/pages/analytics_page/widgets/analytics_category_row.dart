import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/category_dot.dart';

/// One row of the per-category breakdown card: dot + name + amount + a slim
/// share-of-total progress bar (`SpendLens.dc.html`'s "Charts" category-bar
/// list reference).
///
/// Sizes to its own content — no fixed `height:` box around the text
/// (recorded chronic bug: a hardcoded row height clips at larger
/// textScaleFactor).
class AnalyticsCategoryRow extends StatelessWidget {
  final Color color;
  final String name;
  final String amountText;

  /// 0.0–1.0 share of the period total.
  final double share;

  const AnalyticsCategoryRow({
    super.key,
    required this.color,
    required this.name,
    required this.amountText,
    required this.share,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.0,
        children: [
          Row(
            spacing: 8.0,
            children: [
              CategoryDot(color: color),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.body17.copyWith(color: scheme.ink),
                ),
              ),
              Text(
                amountText,
                style: textTheme.body17.copyWith(
                  color: scheme.sec,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              return AppContainer(
                width: trackWidth,
                height: 6.0,
                color: scheme.field,
                borderRadius: BorderRadius.circular(3.0),
                alignment: Alignment.centerLeft,
                child: AppContainer(
                  width: trackWidth * share.clamp(0.0, 1.0),
                  height: 6.0,
                  color: color,
                  borderRadius: BorderRadius.circular(3.0),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

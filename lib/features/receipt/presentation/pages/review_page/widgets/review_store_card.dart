import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// Review's store/date summary card (`SpendLens Prototype.dc.html` line
/// 493): store name, date · time, and an "Auto-detected" badge. Layout only
/// (A6).
class ReviewStoreCard extends StatelessWidget {
  final String storeName;
  final String dateTimeLabel;
  final String autoDetectedLabel;

  const ReviewStoreCard({
    super.key,
    required this.storeName,
    required this.dateTimeLabel,
    required this.autoDetectedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: textTheme.screenTitle28.copyWith(color: scheme.ink),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dateTimeLabel,
                  style: textTheme.subhead15.copyWith(color: scheme.sec),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
            // textScaleFactor — this pill carries the "Auto-detected"
            // label, so MIN-HEIGHT only (the 6dp status dot inside it is
            // the correct FIXED-size decorative case).
            constraints: const BoxConstraints(minHeight: 26.0),
            child: AppContainer(
              color: scheme.accentTint,
              borderRadius: BorderRadius.circular(999.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6.0,
                children: [
                  AppContainer(
                    width: 6.0,
                    height: 6.0,
                    shape: BoxShape.circle,
                    color: scheme.accent,
                  ),
                  Text(
                    autoDetectedLabel,
                    style: textTheme.footnote13.copyWith(
                      color: scheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

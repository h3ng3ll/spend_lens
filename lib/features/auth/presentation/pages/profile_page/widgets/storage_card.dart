import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';

/// Profile artboard's Storage card. M5 has no real sign-in (M9), so the
/// premium storage bar/toggle branch (`sc-if signedIn`) never renders here —
/// only the local, unlimited-storage copy.
class StorageCard extends StatelessWidget {
  final String deviceNoun;

  const StorageCard({super.key, required this.deviceNoun});

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
        spacing: 10.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lo.storage,
                style: textTheme.subhead15.copyWith(color: scheme.ink),
              ),
              Text(
                lo.unlimited,
                style: textTheme.subhead15.copyWith(
                  color: scheme.sec,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          Text(
            lo.limitLocal(deviceNoun),
            style: textTheme.footnote13.copyWith(color: scheme.ter),
          ),
        ],
      ),
    );
  }
}

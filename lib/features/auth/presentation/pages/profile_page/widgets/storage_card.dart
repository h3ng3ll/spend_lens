import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/utils/app_limits.dart';
import '../../../../../../core/widgets/app_section_card.dart';

/// Profile artboard's Storage card (`sc-if signedIn` branch,
/// `SpendLens Prototype.dc.html`). Signed-out shows the local/unlimited
/// copy; signed-in shows the free-tier cloud quota, sourced from
/// [AppLimits] — never a hardcoded "100 MB" (design_spendlens.md §6/§9).
///
/// This app has no image-upload backend (Firebase here is Crashlytics +
/// auth only — design_spendlens.md §1 Step 2), so there is no real "bytes
/// used" figure to report; the design's `togglePremium`/`usedBarStyle`
/// simulation is the explicitly-excluded prototype debug control
/// (design_spendlens.md's "Deliberately not built" list) and is not
/// reproduced here.
class StorageCard extends StatelessWidget {
  final String deviceNoun;
  final bool isSignedIn;

  const StorageCard({
    super.key,
    required this.deviceNoun,
    required this.isSignedIn,
  });

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
                isSignedIn ? lo.cloudStorage : lo.storage,
                style: textTheme.subhead15.copyWith(color: scheme.ink),
              ),
              Text(
                isSignedIn ? AppLimits.freeCloudQuotaLabel : lo.unlimited,
                style: textTheme.subhead15.copyWith(
                  color: scheme.sec,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          Text(
            isSignedIn
                ? lo.limitFree(AppLimits.freeCloudQuotaLabel)
                : lo.limitLocal(deviceNoun),
            style: textTheme.footnote13.copyWith(color: scheme.ter),
          ),
        ],
      ),
    );
  }
}

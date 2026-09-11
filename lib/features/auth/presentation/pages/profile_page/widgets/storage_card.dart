import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/utils/app_limits.dart';
import '../../../../../../core/utils/byte_format.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../sync/presentation/bloc/sync_bloc/sync_bloc.dart';
import 'storage_usage_bar.dart';
import 'upgrade_to_premium_button.dart';

/// Profile artboard's Storage card.
///
/// Signed out: the local/unlimited copy, unchanged.
///
/// Signed in: the quota, a usage bar, and a MEASURED usage figure — summed
/// from real Firebase Storage object metadata by `FirebaseStorageService`,
/// not the design's simulated "38 MB". Receipt photos are compressed to
/// ~200 KB before upload, which is what makes the 100 MB free tier
/// meaningful (roughly 500 receipts) rather than decorative.
///
/// Record documents are excluded from the figure: they are a few hundred
/// bytes each against a 100 MB quota, so counting them would add noise to a
/// number the user reads as "how much room is left for photos". The footnote
/// says so rather than leaving the reader to guess.
class StorageCard extends StatelessWidget {
  final String deviceNoun;
  final bool isSignedIn;

  /// Whether the purchase SDK started, so the Upgrade button can be honest.
  final bool isPurchaseAvailable;

  final VoidCallback onUpgrade;

  const StorageCard({
    super.key,
    required this.deviceNoun,
    required this.isSignedIn,
    required this.isPurchaseAvailable,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, syncState) {
        final quotaLabel = syncState.isPremium
            ? AppLimits.premiumCloudQuotaLabel
            : AppLimits.freeCloudQuotaLabel;

        return AppSectionCard(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 18.0,
          ),
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
                    isSignedIn
                        ? lo.storageUsedOf(
                            formatBytes(syncState.usedBytes),
                            quotaLabel,
                          )
                        : lo.unlimited,
                    style: textTheme.subhead15.copyWith(
                      color: scheme.sec,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              if (isSignedIn) StorageUsageBar(fraction: syncState.usedFraction),
              Text(
                // `limitPremium` vs `limitFree` — not just the quota NUMBER.
                // A premium user previously read "Free accounts include
                // 5 GB", which contradicts the badge beside it and misstates
                // what they paid for.
                isSignedIn
                    ? (syncState.isPremium
                        ? lo.limitPremium(quotaLabel)
                        : lo.limitFree(quotaLabel))
                    : lo.limitLocal(deviceNoun),
                style: textTheme.footnote13.copyWith(color: scheme.ter),
              ),
              if (isSignedIn)
                Text(
                  lo.storageEstimateNote,
                  style: textTheme.footnote13.copyWith(color: scheme.ter),
                ),
              if (isSignedIn && !syncState.isPremium)
                UpgradeToPremiumButton(
                  isPurchaseAvailable: isPurchaseAvailable,
                  onUpgrade: onUpgrade,
                ),
            ],
          ),
        );
      },
    );
  }
}

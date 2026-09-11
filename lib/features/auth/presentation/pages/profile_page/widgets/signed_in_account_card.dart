import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/settings_row.dart';
import '../../../../../sync/presentation/bloc/sync_bloc/sync_bloc.dart';
import 'cloud_sync_row.dart';
import 'plan_badge.dart';

/// Profile artboard's signed-in-only card (`sc-if signedIn` block in
/// `SpendLens Prototype.dc.html`) — account email, plan badge, cloud-sync
/// status, and Sign out. Shown only when [AuthState.isSignedIn].
///
/// The plan row reads `SyncBloc.isPremium` — the SAME source `StorageCard`
/// uses for the quota — rather than the hardcoded `lo.free` it carried
/// before. That hardcoding was visible as a real defect: after a successful
/// upgrade the cloud quota grew to the premium figure while this badge kept
/// reading "Free", so one card contradicted the other on the same screen.
class SignedInAccountCard extends StatelessWidget {
  final String email;
  final VoidCallback onSignOut;

  const SignedInAccountCard({
    super.key,
    required this.email,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsRow(
            label: lo.account,
            trailingText: email,
            showChevron: false,
          ),
          BlocBuilder<SyncBloc, SyncState>(
            buildWhen: (previous, current) =>
                previous.isPremium != current.isPremium,
            builder: (context, syncState) => SettingsRow(
              label: lo.plan,
              trailing: PlanBadge(
                label: syncState.isPremium ? lo.premium : lo.free,
                isPremium: syncState.isPremium,
              ),
              showChevron: false,
            ),
          ),
          // Real sync state, not a hardcoded string — see CloudSyncRow.
          const CloudSyncRow(),
          SettingsRow(
            label: lo.signOut,
            labelColor: scheme.warn,
            showChevron: false,
            showBottomDivider: false,
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}

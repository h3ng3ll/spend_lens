import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/settings_row.dart';

/// Profile artboard's signed-in-only card (`sc-if signedIn` block in
/// `SpendLens Prototype.dc.html`) — account email, plan badge, cloud-sync
/// status, and Sign out. Shown only when [AuthState.isSignedIn].
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
          SettingsRow(
            label: lo.plan,
            trailingText: lo.free,
            trailingTextColor: scheme.sec,
            showChevron: false,
          ),
          SettingsRow(
            label: lo.cloudSync,
            trailingText: lo.upToDate,
            trailingTextColor: scheme.accent2,
            showChevron: false,
          ),
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

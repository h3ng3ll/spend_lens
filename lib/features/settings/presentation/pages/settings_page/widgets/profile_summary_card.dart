import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../auth/presentation/bloc/auth_bloc/auth_bloc.dart';

/// Settings artboard's tappable profile-summary card: avatar + name/status
/// line + chevron, navigating to Profile.
///
/// **Reads [AuthState] reactively.** The name/status lines were previously
/// the hardcoded "Local account" / "Not signed in" strings from M5, when no
/// real sign-in existed. Once M9 landed the real flow, that made the card lie:
/// a user could sign in on the Profile screen, come back, and still be told
/// they were on a local account — the card had no subscription to auth state,
/// so nothing could ever change it.
///
/// The identity copy here mirrors [ProfileIdentityColumn] exactly (same
/// getters, same l10n keys) so the two screens can never disagree about who
/// is signed in.
class ProfileSummaryCard extends StatelessWidget {
  final AuthState state;
  final VoidCallback onTap;

  const ProfileSummaryCard({
    super.key,
    required this.state,
    required this.onTap,
  });

  static const double _avatarSize = 48.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    // Same derivation as ProfileIdentityColumn — signed in shows the account
    // email, signed out keeps the neutral local-account copy.
    final displayName = state.isSignedIn && state.email.isNotEmpty
        ? state.email
        : lo.localAccount;
    final statusLabel = state.isSignedIn ? lo.signedInGoogle : lo.notSignedIn;
    final statusColor = state.isSignedIn ? scheme.accent2 : scheme.ter;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppSectionCard(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          spacing: 14.0,
          children: [
            AppContainer(
              width: _avatarSize,
              height: _avatarSize,
              color: scheme.accentTint,
              shape: BoxShape.circle,
              alignment: Alignment.center,
              child: AppSvgIcon(
                asset: AppIcons.user,
                color: scheme.accent,
                size: 24.0,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: textTheme.headline17Semi.copyWith(color: scheme.ink),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    statusLabel,
                    style: textTheme.footnote13.copyWith(color: statusColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppSvgIcon(
              asset: AppIcons.chevronRight,
              color: scheme.ter,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}

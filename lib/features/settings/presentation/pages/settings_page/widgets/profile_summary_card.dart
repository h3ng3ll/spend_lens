import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/build_avatar.dart';
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

    // Same derivation as ProfileIdentityColumn — the NAME when one is set,
    // otherwise the account email, and the neutral local-account copy when
    // signed out. Both surfaces read the same getters so they can never
    // disagree about who is signed in.
    final displayName = state.isSignedIn && state.identityPrimary.isNotEmpty
        ? state.identityPrimary
        : lo.localAccount;
    final statusLabel = switch (state) {
      _ when state.isNotSignedIn => lo.notSignedIn,
      _ when state.isGoogleAccount => lo.signedInGoogle,
      _ => lo.signedInApple,
    };
    final statusColor = state.isSignedIn ? scheme.accent2 : scheme.ter;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppSectionCard(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          spacing: 14.0,
          children: [
            BuildAvatar(filename: state.avatarFilename, size: _avatarSize),
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

import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// Settings artboard's tappable profile-summary card: avatar + name/status
/// line + chevron, navigating to Profile.
///
/// M5 has no real signed-in user, so the name/status lines use the neutral
/// "local account / not signed in" copy rather than invented user data.
class ProfileSummaryCard extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileSummaryCard({super.key, required this.onTap});

  static const double _avatarSize = 48.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

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
                    lo.localAccount,
                    style: textTheme.headline17Semi.copyWith(color: scheme.ink),
                  ),
                  Text(
                    lo.notSignedIn,
                    style: textTheme.footnote13.copyWith(color: scheme.ter),
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

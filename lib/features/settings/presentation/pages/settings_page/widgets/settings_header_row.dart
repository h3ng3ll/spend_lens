import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// Settings artboard's top row: the screen title, plus a small circular
/// avatar button navigating to Profile.
///
/// M5 has no real signed-in user (design_spendlens.md — sign-in is M9), so
/// the avatar renders a neutral placeholder glyph rather than an initial —
/// there is no name to derive an initial from yet.
class SettingsHeaderRow extends StatelessWidget {
  final VoidCallback onAvatarTap;

  const SettingsHeaderRow({super.key, required this.onAvatarTap});

  static const double _avatarSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lo.settings,
          style: textTheme.screenTitle28.copyWith(color: scheme.ink),
        ),
        GestureDetector(
          onTap: onAvatarTap,
          behavior: HitTestBehavior.opaque,
          child: AppContainer(
            width: _avatarSize,
            height: _avatarSize,
            color: scheme.accentTint,
            shape: BoxShape.circle,
            border: Border.all(color: scheme.field2, width: 2.0),
            alignment: Alignment.center,
            child: AppSvgIcon(
              asset: AppIcons.user,
              color: scheme.accent,
              size: 20.0,
            ),
          ),
        ),
      ],
    );
  }
}

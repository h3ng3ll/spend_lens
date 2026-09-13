
import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/build_avatar.dart';

/// Settings artboard's top row: the screen title, plus a small circular
/// avatar button navigating to Profile.
///
/// Renders the user's avatar when one is set, falling back to [BuildImage]'s
/// neutral placeholder glyph otherwise. The bytes come from [AuthState], which
/// the caller already watches — this widget opens no subscription of its own.
///
/// Tapping always navigates to Profile, signed in or not: this is a navigation
/// control, not the edit affordance. Editing lives on the Profile screen and
/// is hidden entirely while signed out.
class SettingsHeaderRow extends StatelessWidget {
  final VoidCallback onAvatarTap;
  final String avatarFilename;

  const SettingsHeaderRow({
    super.key,
    required this.onAvatarTap,
    this.avatarFilename = '',
  });

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
          child: BuildAvatar(
            filename: avatarFilename,
            size: _avatarSize,
            border: Border.all(color: scheme.field2, width: 2.0),
          ),
        ),
      ],
    );
  }
}

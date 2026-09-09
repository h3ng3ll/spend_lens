import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/category_dot.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';

/// Profile artboard's identity block: 88dp avatar, name, and a status pill
/// (dot + text) reflecting [AuthState] — signed-out renders in a neutral/
/// secondary style, and the signed-in label names the ACTUAL provider that
/// [AuthState.isGoogleAccount] reports (design_spendlens.md — M9).
class ProfileIdentityColumn extends StatelessWidget {
  final AuthState state;

  const ProfileIdentityColumn({super.key, required this.state});

  static const double _avatarSize = 88.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    // The provider comes from `isGoogleAccount`, which the bloc derives from
    // Firebase's `providerData`. Hardcoding the Google string here made an
    // Apple sign-in report "Signed in with Google".
    final statusLabel = switch (state) {
      _ when state.isNotSignedIn => lo.notSignedIn,
      _ when state.isGoogleAccount => lo.signedInGoogle,
      _ => lo.signedInApple,
    };
    final statusColor = state.isSignedIn ? scheme.accent2 : scheme.sec;
    final displayName = state.isSignedIn && state.email.isNotEmpty
        ? state.email
        : lo.localAccount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.0,
      children: [
        AppContainer(
          width: _avatarSize,
          height: _avatarSize,
          color: scheme.accentTint,
          shape: BoxShape.circle,
          border: Border.all(color: scheme.line2, width: 3.0),
          alignment: Alignment.center,
          child: AppSvgIcon(
            asset: AppIcons.user,
            color: scheme.accent,
            size: 40.0,
          ),
        ),
        Text(
          displayName,
          style: textTheme.headline17Semi.copyWith(color: scheme.ink),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 26.0),
          child: AppContainer(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6.0,
              children: [
                CategoryDot(color: statusColor, size: 6.0),
                Text(
                  statusLabel,
                  style: textTheme.footnote13.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

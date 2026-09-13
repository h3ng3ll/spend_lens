import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/build_avatar.dart';
import '../../../../../../core/widgets/category_dot.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';

/// Profile artboard's identity block: 88dp avatar, name, and a status pill
/// (dot + text) reflecting [AuthState] — signed-out renders in a neutral/
/// secondary style, and the signed-in label names the ACTUAL provider that
/// [AuthState.isGoogleAccount] reports (design_spendlens.md — M9).
///
/// The avatar is TAPPABLE only while signed in. For a signed-out user the
/// whole editing feature is HIDDEN, not disabled: there is no account to
/// attach a name or photo to, and the sign-in card directly below is already
/// the call to action. So the signed-out avatar is exactly what it always was
/// — a plain, inert circle with the placeholder glyph.
class ProfileIdentityColumn extends StatelessWidget {
  final AuthState state;

  /// Opens the edit screen. Wired only when [AuthStateX.canEditProfile].
  final VoidCallback onEdit;

  const ProfileIdentityColumn({
    super.key,
    required this.state,
    required this.onEdit,
  });

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

    // Name first, email beneath. Falls back to the email alone when no name
    // is set, so an account that predates names reads exactly as it did.
    final primary = state.isSignedIn && state.identityPrimary.isNotEmpty
        ? state.identityPrimary
        : lo.localAccount;
    final secondary = state.isSignedIn ? state.identitySecondary : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.0,
      children: [
        _avatar(context, scheme),
        Text(
          primary,
          textAlign: TextAlign.center,
          style: textTheme.headline17Semi.copyWith(color: scheme.ink),
        ),
        if (secondary.isNotEmpty)
          Text(
            secondary,
            textAlign: TextAlign.center,
            style: textTheme.footnote13.copyWith(color: scheme.sec),
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

  Widget _avatar(BuildContext context, AppColorScheme scheme) {
    final image = BuildAvatar(
      filename: state.avatarFilename,
      size: _avatarSize,
      border: Border.all(color: scheme.line2, width: 3.0),
    );

    if (!state.canEditProfile) return image;

    return GestureDetector(
      onTap: onEdit,
      behavior: HitTestBehavior.opaque,
      child: image,
    );
  }
}

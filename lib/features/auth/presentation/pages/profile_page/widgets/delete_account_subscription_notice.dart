import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// Warns, inside the delete-account sheet, that deleting the account does NOT
/// cancel the subscription.
///
/// **Why this has to be said before the choice, not after.** The subscription
/// is owned by the App Store / Play billing, not by this app's account: nothing
/// in the deletion path can cancel it, and nothing does. Without this notice a
/// user deletes their account, watches every trace of it disappear, and keeps
/// being charged for a Premium tier attached to an account that no longer
/// exists — with no way back into the app to discover why.
///
/// Shown only while a subscription is actually active. For a free user there is
/// no billing to warn about, and an unconditional warning would be noise at the
/// exact moment the user needs to read carefully.
class DeleteAccountSubscriptionNotice extends StatelessWidget {
  /// Opens the platform's subscription-management screen, so the warning comes
  /// with the means to act on it rather than only bad news.
  final VoidCallback onManage;

  const DeleteAccountSubscriptionNotice({super.key, required this.onManage});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return HorizontalPadding(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AppContainer(
          color: scheme.warnTint,
          borderRadius: BorderRadius.circular(14.0),
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10.0,
                children: [
                  AppSvgIcon(
                    asset: AppIcons.warning,
                    color: scheme.warn,
                    size: 18.0,
                  ),
                  Expanded(
                    child: Text(
                      lo.deleteAccountSubscriptionTitle,
                      style: textTheme.subhead15.copyWith(
                        color: scheme.warn,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                lo.deleteAccountSubscriptionBody,
                style: textTheme.footnote13.copyWith(color: scheme.ink),
              ),
              GestureDetector(
                onTap: onManage,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  lo.deleteAccountSubscriptionAction,
                  style: textTheme.footnote13.copyWith(
                    color: scheme.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

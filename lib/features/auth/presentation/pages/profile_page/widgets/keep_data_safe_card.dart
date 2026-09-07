import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// Profile artboard's "Keep your data safe" card — shown only when NOT
/// signed in. Both buttons dispatch the real Google/Apple sign-in events
/// (M9, design_spendlens.md §9 — template bugs 1–5 fixed).
class KeepDataSafeCard extends StatelessWidget {
  final String deviceNoun;
  final VoidCallback onGoogle;
  final VoidCallback onApple;

  const KeepDataSafeCard({
    super.key,
    required this.deviceNoun,
    required this.onGoogle,
    required this.onApple,
  });

  static const double _buttonMinHeight = 52.0;

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          Text(
            lo.keepSafe,
            style: textTheme.headline17Semi.copyWith(color: scheme.ink),
          ),
          Text(
            lo.keepSafeBody(deviceNoun),
            style: textTheme.subhead15.copyWith(color: scheme.sec),
          ),
          GestureDetector(
            onTap: onGoogle,
            behavior: HitTestBehavior.opaque,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _buttonMinHeight),
              child: AppContainer(
                color: AppColors.white.value,
                border: Border.all(
                  color: AppColors.inkLight.value.withValues(alpha: 0.12),
                ),
                borderRadius: BorderRadius.circular(14.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10.0,
                  children: [
                    SvgPicture.asset(
                      AppIcons.googleLogo,
                      width: 18.0,
                      height: 18.0,
                    ),
                    Text(
                      lo.continueGoogle,
                      style: textTheme.body17.copyWith(
                        color: AppColors.inkLight.value,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onApple,
            behavior: HitTestBehavior.opaque,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _buttonMinHeight),
              child: AppContainer(
                color: scheme.field,
                border: Border.all(color: scheme.line2),
                borderRadius: BorderRadius.circular(14.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10.0,
                  children: [
                    AppSvgIcon(
                      asset: AppIcons.appleLogo,
                      color: scheme.ink,
                      size: 18.0,
                    ),
                    Text(
                      lo.continueApple,
                      style: textTheme.body17.copyWith(
                        color: scheme.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

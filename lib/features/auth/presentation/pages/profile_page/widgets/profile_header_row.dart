import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/utils/extensions/go_router_x.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// Profile artboard's header: a circular back button, the centered title,
/// and a 40dp spacer so the title stays visually centered
/// (design_spendlens.md's Profile artboard — `goSettings` back control).
class ProfileHeaderRow extends StatelessWidget {
  const ProfileHeaderRow({super.key});

  static const double _controlSize = 40.0;

  void _onBack(BuildContext context) => context.goBack();

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _onBack(context),
          behavior: HitTestBehavior.opaque,
          child: AppContainer(
            width: _controlSize,
            height: _controlSize,
            color: scheme.card,
            border: Border.all(color: scheme.line, width: 1.0),
            shape: BoxShape.circle,
            alignment: Alignment.center,
            child: AppSvgIcon(
              asset: AppIcons.chevronLeft,
              color: scheme.ink,
              size: 18.0,
            ),
          ),
        ),
        Text(
          lo.profile,
          style: textTheme.headline17Semi.copyWith(color: scheme.ink),
        ),
        const SizedBox(width: _controlSize),
      ],
    );
  }
}

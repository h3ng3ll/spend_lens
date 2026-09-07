import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// Review's own header row (`SpendLens Prototype.dc.html` line 488): a
/// circular back button, centered title, and a "Retake" trailing action.
/// Layout only (A6) — callbacks and title text arrive from the parent page.
class ReviewHeader extends StatelessWidget {
  final String title;
  final String retakeLabel;
  final VoidCallback onBack;
  final VoidCallback onRetake;

  const ReviewHeader({
    super.key,
    required this.title,
    required this.retakeLabel,
    required this.onBack,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onBack,
          child: AppContainer(
            width: 40.0,
            height: 40.0,
            color: scheme.card,
            border: Border.all(color: scheme.line, width: 1.0),
            shape: BoxShape.circle,
            alignment: Alignment.center,
            child: AppSvgIcon(
              asset: AppIcons.chevronLeft,
              color: scheme.ink,
              size: 16.0,
            ),
          ),
        ),
        Text(
          title,
          style: textTheme.headline17Semi.copyWith(color: scheme.ink),
        ),
        GestureDetector(
          onTap: onRetake,
          child: ConstrainedBox(
            // ⛔ sig:developer-derived-fixed-dp-cell-height-ignores-
            // textScaleFactor — this box carries user-facing text
            // ("Retake"), so MIN-HEIGHT/MIN-WIDTH only, never a fixed
            // `height:`/`width:` (the icon-only back button on this same
            // row is the correct FIXED-size case for comparison).
            constraints: const BoxConstraints(minWidth: 56.0, minHeight: 40.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                retakeLabel,
                style: textTheme.subhead15.copyWith(
                  color: scheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_svg_icon.dart';

/// One "what you get" line on the premium upgrade sheet: an accent check
/// glyph and the benefit text.
class PremiumFeatureRow extends StatelessWidget {
  final String label;

  const PremiumFeatureRow({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.0,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: AppSvgIcon(
            asset: AppIcons.check,
            size: 18.0,
            color: scheme.accent,
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: textTheme.subhead15.copyWith(
              color: scheme.sec,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

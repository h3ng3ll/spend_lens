import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../language_option.dart';

/// One row of the Language sheet's list. Layout only — [onTap] is supplied
/// by the sheet, which owns the bloc dispatch (A2 — no inline bloc dispatch
/// inside a widget's own callback).
class LanguageOptionRow extends StatelessWidget {
  final LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  const LanguageOptionRow({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return InkWell(
      onTap: onTap,
      child: HorizontalPadding(
        child: SizedBox(
          height: 56.0,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.label,
                  style: textTheme.headline17.copyWith(color: scheme.ink),
                ),
              ),
              if (selected)
                SvgPicture.asset(
                  AppIcons.check,
                  width: 20.0,
                  height: 20.0,
                  colorFilter: ColorFilter.mode(
                    scheme.accent,
                    BlendMode.srcIn,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

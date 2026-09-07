import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../currency_option.dart';

/// One row of the Currency sheet's list. Layout only — [onTap] is supplied
/// by the sheet, which owns the bloc dispatch (A2).
class CurrencyOptionRow extends StatelessWidget {
  final CurrencyOption option;
  final bool selected;
  final VoidCallback onTap;

  const CurrencyOptionRow({
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
            spacing: 12.0,
            children: [
              Text(
                option.code,
                style: textTheme.headline17Semi.copyWith(color: scheme.ink),
              ),
              Expanded(
                child: Text(
                  option.name,
                  style: textTheme.subhead15.copyWith(color: scheme.sec),
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

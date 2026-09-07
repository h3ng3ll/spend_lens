import 'package:flutter/material.dart';

import '../resources/app_icons.dart';
import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';
import 'app_svg_icon.dart';

/// The shared header row for the manual-entry top-level pages this feature
/// slice owns (Cash expense, Categories, New category, Choose store, New
/// store) — a circular close (X) button, a centered title, and a
/// width-matched trailing spacer so the title stays visually centered
/// (design_spendlens.md's artboards: every one of these screens repeats
/// this exact `closeX / centered title / 40px spacer` row verbatim).
///
/// Not `CustomAppBar`: that widget renders a back-arrow `AppBar` for the
/// shell's push stack, not this bespoke close-X row every M5 sheet-like
/// page uses instead (same reasoning as `StorePageAppBar`'s doc comment).
class SheetCloseHeader extends StatelessWidget {
  static const double _buttonSize = 40.0;

  final String title;
  final VoidCallback onClose;

  const SheetCloseHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onClose,
          child: AppContainer(
            width: _buttonSize,
            height: _buttonSize,
            color: scheme.card,
            border: Border.all(color: scheme.line, width: 1.0),
            shape: BoxShape.circle,
            alignment: Alignment.center,
            child: AppSvgIcon(
              asset: AppIcons.close,
              color: scheme.ink,
              size: 16.0,
            ),
          ),
        ),
        Text(
          title,
          style: textTheme.headline17Semi.copyWith(color: scheme.ink),
        ),
        const SizedBox(width: _buttonSize),
      ],
    );
  }
}

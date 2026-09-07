import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The "+ New Store" pill (design_spendlens.md's Stores artboard —
/// `openNewStore`): `--card` fill, `--line` hairline border, accent text.
class NewStorePillButton extends StatelessWidget {
  final VoidCallback onTap;

  const NewStorePillButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        height: 36.0,
        color: scheme.card,
        border: Border.all(color: scheme.line, width: 1.0),
        borderRadius: BorderRadius.circular(999.0),
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 14.0, 0.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6.0,
          children: [
            Text(
              '+',
              style: textTheme.headline17.copyWith(
                color: scheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              lo.newStore,
              style: textTheme.footnote13.copyWith(
                color: scheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

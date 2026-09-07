import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../../core/widgets/settings_row.dart';

/// About artboard content: version row + a short, generic description of
/// what the app does. The app NAME is never rendered per project rules —
/// this is generic copy only (design_spendlens.md §12: "design shows the
/// rows, not the text; plain markdown from assets" — the real copy sourcing
/// is M10; this milestone ships honest, non-invented placeholder text).
class AboutBody extends StatelessWidget {
  final String versionLabel;

  const AboutBody({super.key, required this.versionLabel});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8.0),
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            AppSectionCard(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SettingsRow(
                label: lo.about,
                trailingText: versionLabel,
                showChevron: false,
                showBottomDivider: false,
              ),
            ),
            Text(
              lo.aboutDescription,
              style: textTheme.subhead15.copyWith(
                color: scheme.sec,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

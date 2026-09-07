import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../bloc/settings_bloc/settings_bloc.dart';

/// M4 minimal placeholder rows for the Settings tab (the design's full
/// grouped-row layout, category management link and account/plan section
/// are M5/M9). Proves the three real actions this milestone needs to be
/// reachable: Language sheet, Currency sheet, Appearance toggle.
class SettingsBody extends StatelessWidget {
  final SettingsState state;
  final VoidCallback onLanguage;
  final VoidCallback onCurrency;
  final VoidCallback onToggleTheme;

  const SettingsBody({
    super.key,
    required this.state,
    required this.onLanguage,
    required this.onCurrency,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return HorizontalPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16.0,
        children: [
          GestureDetector(
            onTap: onLanguage,
            child: Text(
              lo.language,
              style: textTheme.body17.copyWith(color: scheme.ink),
            ),
          ),
          GestureDetector(
            onTap: onCurrency,
            child: Text(
              lo.currency,
              style: textTheme.body17.copyWith(color: scheme.ink),
            ),
          ),
          GestureDetector(
            onTap: onToggleTheme,
            child: Text(
              lo.appearance,
              style: textTheme.body17.copyWith(color: scheme.ink),
            ),
          ),
        ],
      ),
    );
  }
}

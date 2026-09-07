import 'package:flutter/material.dart';

import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/appearance_toggle.dart';
import '../../../../../../core/widgets/settings_row.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../domain/models/app_settings/e_app_theme_mode.dart';

/// The first grouped card of the Settings artboard: Currency, Categories,
/// Language, Appearance.
class PreferencesCard extends StatelessWidget {
  final String currencyLabel;
  final String languageLabel;
  final int categoryCount;
  final EAppThemeMode themeMode;
  final VoidCallback onCurrency;
  final VoidCallback onCategories;
  final VoidCallback onLanguage;
  final VoidCallback onToggleTheme;

  const PreferencesCard({
    super.key,
    required this.currencyLabel,
    required this.languageLabel,
    required this.categoryCount,
    required this.themeMode,
    required this.onCurrency,
    required this.onCategories,
    required this.onLanguage,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    final isDark = themeMode != EAppThemeMode.light;

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsRow(
            label: lo.currency,
            trailingText: currencyLabel,
            trailingTextColor: scheme.accent,
            onTap: onCurrency,
          ),
          SettingsRow(
            label: lo.categories,
            trailingText: '$categoryCount',
            onTap: onCategories,
          ),
          SettingsRow(
            label: lo.language,
            trailingText: languageLabel,
            trailingTextColor: scheme.accent,
            onTap: onLanguage,
          ),
          SettingsRow(
            label: lo.appearance,
            showChevron: false,
            showBottomDivider: false,
            trailing: AppearanceToggle(
              isDark: isDark,
              darkLabel: lo.dark,
              lightLabel: lo.light,
              onToggle: onToggleTheme,
            ),
          ),
        ],
      ),
    );
  }
}

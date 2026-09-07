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
  final ValueChanged<EAppThemeMode> onPickTheme;

  const PreferencesCard({
    super.key,
    required this.currencyLabel,
    required this.languageLabel,
    required this.categoryCount,
    required this.themeMode,
    required this.onCurrency,
    required this.onCategories,
    required this.onLanguage,
    required this.onPickTheme,
  });

  void _onPickDark() => onPickTheme(EAppThemeMode.dark);

  void _onPickLight() => onPickTheme(EAppThemeMode.light);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    // `system` must resolve against the ACTUAL platform brightness, never
    // fall silently onto dark — otherwise a light-rendered device shows
    // "Dark" highlighted while the app is visibly light (R2-6).
    final isDark = switch (themeMode) {
      EAppThemeMode.dark => true,
      EAppThemeMode.light => false,
      EAppThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };

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
              onPickDark: _onPickDark,
              onPickLight: _onPickLight,
            ),
          ),
        ],
      ),
    );
  }
}

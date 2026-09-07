import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/widgets/app_container.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../bloc/settings_bloc/settings_bloc.dart';
import 'language_option.dart';
import 'widgets/language_option_row.dart';

/// The Language picker — a bottom sheet, NOT a route (design_spendlens.md
/// §5). Reads the live [SettingsBloc] via [BlocBuilder] (bottom sheets with
/// bloc data must never take a one-shot snapshot) so the checkmark updates
/// the instant a pick is persisted.
///
/// Recorded global bug
/// `language-picker-writes-domain-field-materialapp-locale-never-bound`: this
/// sheet dispatches `SettingsEvent.setLocale`, and `main.dart` binds
/// `MaterialApp.locale` to `SettingsState.resolvedLocale` — the write path
/// and the read path are the SAME field, not a domain field nothing reads.
class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  static Future<void> show(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) =>
          BlocProvider.value(value: bloc, child: const LanguageSheet()),
    );
  }

  List<LanguageOption> _options(AppLocalizations lo) => [
    LanguageOption(code: null, label: lo.language),
    const LanguageOption(code: 'en', label: 'English'),
    const LanguageOption(code: 'ro', label: 'Română'),
    const LanguageOption(code: 'ru', label: 'Русский'),
    const LanguageOption(code: 'uk', label: 'Українська'),
    const LanguageOption(code: 'es', label: 'Español'),
    const LanguageOption(code: 'de', label: 'Deutsch'),
    const LanguageOption(code: 'fr', label: 'Français'),
  ];

  void _onSelect(BuildContext context, String? code) {
    context.read<SettingsBloc>().add(SettingsEvent.setLocale(code: code));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return SafeArea(
      child: AppContainer(
        color: scheme.sheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final options = _options(lo);
            final selectedCode = state.settings.localeCode;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.0,
                children: [
                  HorizontalPadding(
                    child: Text(
                      lo.language,
                      style: textTheme.headline17Semi.copyWith(
                        color: scheme.ink,
                      ),
                    ),
                  ),
                  ...options.map(
                    (option) => LanguageOptionRow(
                      option: option,
                      selected: option.code == selectedCode,
                      onTap: () => _onSelect(context, option.code),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

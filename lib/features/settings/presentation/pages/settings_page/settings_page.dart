import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../bloc/settings_bloc/settings_bloc.dart';
import '../../sheets/currency_sheet/currency_sheet.dart';
import '../../sheets/language_sheet/language_sheet.dart';
import 'widgets/settings_body.dart';

/// `SettingsPageRoute` — the Settings branch of the 5-tab shell
/// (design_spendlens.md §5).
///
/// [SettingsBloc] is an app-lifetime, `registerLazySingleton` bloc
/// dispatched once from `main()` (BLoC rule A3.8) — this page reads the
/// EXISTING instance via `context.read`, it never constructs its own.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _onLanguage(BuildContext context) => LanguageSheet.show(context);

  void _onCurrency(BuildContext context) => CurrencySheet.show(context);

  void _onToggleTheme(BuildContext context) =>
      context.read<SettingsBloc>().add(const SettingsEvent.toggleTheme());

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.tabSettings)),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => SettingsBody(
          state: state,
          onLanguage: () => _onLanguage(context),
          onCurrency: () => _onCurrency(context),
          onToggleTheme: () => _onToggleTheme(context),
        ),
      ),
    );
  }
}

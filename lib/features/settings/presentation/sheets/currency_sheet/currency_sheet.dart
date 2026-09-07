import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/widgets/app_container.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../bloc/settings_bloc/settings_bloc.dart';
import 'currency_option.dart';
import 'widgets/currency_option_row.dart';

/// The Currency picker — a bottom sheet, NOT a route (design_spendlens.md
/// §5). Display-only: the chosen currency is used for totals/analytics
/// labelling; receipts always keep their own printed currency (design
/// conflict resolution "No conversion").
class CurrencySheet extends StatelessWidget {
  const CurrencySheet({super.key});

  static Future<void> show(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: const CurrencySheet(),
      ),
    );
  }

  static const _options = [
    CurrencyOption(code: 'MDL', name: 'Moldovan leu'),
    CurrencyOption(code: 'EUR', name: 'Euro'),
    CurrencyOption(code: 'RON', name: 'Romanian leu'),
    CurrencyOption(code: 'USD', name: 'US dollar'),
    CurrencyOption(code: 'UAH', name: 'Ukrainian hryvnia'),
    CurrencyOption(code: 'GBP', name: 'British pound'),
  ];

  void _onSelect(BuildContext context, String code) {
    context.read<SettingsBloc>().add(SettingsEvent.setCurrency(code: code));
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
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final selectedCode = state.settings.currencyCode;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.0,
                children: [
                  HorizontalPadding(
                    child: Text(
                      lo.currency,
                      style: textTheme.headline17Semi.copyWith(
                        color: scheme.ink,
                      ),
                    ),
                  ),
                  ..._options.map(
                    (option) => CurrencyOptionRow(
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

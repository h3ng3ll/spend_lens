import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../category/presentation/bloc/categories_bloc/categories_bloc.dart';
import '../../../bloc/settings_bloc/settings_bloc.dart';
import 'delete_all_card.dart';
import 'legal_card.dart';
import 'preferences_card.dart';
import 'profile_summary_card.dart';
import 'settings_header_row.dart';

/// The Settings artboard's full grouped-card layout
/// (design_spendlens.md §10, verified at `SpendLens Prototype.dc.html`'s
/// `data-screen-label="Settings"` block): header + profile summary, then
/// three grouped cards (preferences, destructive delete-all, legal).
///
/// Reads [CategoriesBloc] (app-lifetime, already provided at the app root)
/// only for the Categories row's trailing count — a read, not a business
/// decision, so this stays within A3.6's foreign-state guard.
class SettingsBody extends StatelessWidget {
  final SettingsState state;
  final String languageLabel;
  final String currencyLabel;
  final String versionLabel;
  final VoidCallback onProfile;
  final VoidCallback onCurrency;
  final VoidCallback onCategories;
  final VoidCallback onLanguage;
  final VoidCallback onToggleTheme;
  final VoidCallback onDeleteAll;
  final VoidCallback onPrivacy;
  final VoidCallback onAbout;

  const SettingsBody({
    super.key,
    required this.state,
    required this.languageLabel,
    required this.currencyLabel,
    required this.versionLabel,
    required this.onProfile,
    required this.onCurrency,
    required this.onCategories,
    required this.onLanguage,
    required this.onToggleTheme,
    required this.onDeleteAll,
    required this.onPrivacy,
    required this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            SettingsHeaderRow(onAvatarTap: onProfile),
            ProfileSummaryCard(onTap: onProfile),
            BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, categoriesState) => PreferencesCard(
                currencyLabel: currencyLabel,
                languageLabel: languageLabel,
                categoryCount: categoriesState.categories.length,
                themeMode: state.settings.themeMode,
                onCurrency: onCurrency,
                onCategories: onCategories,
                onLanguage: onLanguage,
                onToggleTheme: onToggleTheme,
              ),
            ),
            DeleteAllCard(onTap: onDeleteAll),
            LegalCard(
              onPrivacy: onPrivacy,
              onAbout: onAbout,
              versionLabel: versionLabel,
            ),
          ],
        ),
      ),
    );
  }
}

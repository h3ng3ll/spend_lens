import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/scan_capability/e_scan_capability.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import '../../../../../category/presentation/bloc/categories_bloc/categories_bloc.dart';
import '../../../../domain/models/app_settings/e_app_theme_mode.dart';
import '../../../bloc/settings_bloc/settings_bloc.dart';
import 'delete_all_card.dart';
import 'legal_card.dart';
import 'preferences_card.dart';
import 'profile_summary_card.dart';
import 'scan_capability_card.dart';
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
  final ValueChanged<EAppThemeMode> onPickTheme;
  final VoidCallback onDeleteAll;
  final VoidCallback onPrivacy;
  final VoidCallback onAbout;
  /// `null` while the capability probe is in flight — passed straight
  /// through to [ScanCapabilityRow], which renders a neutral "checking"
  /// state rather than a fabricated concrete cause.
  final EScanCapability? scanCapability;
  final VoidCallback onOpenScanSettings;

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
    required this.onPickTheme,
    required this.onDeleteAll,
    required this.onPrivacy,
    required this.onAbout,
    required this.scanCapability,
    required this.onOpenScanSettings,
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
            // Subscribed to AuthBloc so signing in/out on the Profile screen
            // is reflected here immediately. AuthBloc is the app-lifetime
            // singleton provided in main(); this only listens to it.
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) => ProfileSummaryCard(
                state: authState,
                onTap: onProfile,
              ),
            ),
            BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, categoriesState) => PreferencesCard(
                currencyLabel: currencyLabel,
                languageLabel: languageLabel,
                categoryCount: categoriesState.categories.length,
                themeMode: state.settings.themeMode,
                onCurrency: onCurrency,
                onCategories: onCategories,
                onLanguage: onLanguage,
                onPickTheme: onPickTheme,
              ),
            ),
            ScanCapabilityCard(
              capability: scanCapability,
              onOpenSettings: onOpenScanSettings,
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

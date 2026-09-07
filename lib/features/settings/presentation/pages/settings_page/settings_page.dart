import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../../category/domain/repositories/i_category_local_repository.dart';
import '../../../../expense/domain/repositories/i_expense_local_repository.dart';
import '../../../../store/domain/repositories/i_store_local_repository.dart';
import '../../../domain/use_cases/delete_all_records_use_case.dart';
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
///
/// No `CustomAppBar` — the Settings artboard (`SpendLens Prototype.dc.html`,
/// `data-screen-label="Settings"`) has its own bespoke title + avatar row
/// (`SettingsHeaderRow`), matching Home/Analytics's pattern for a shell
/// branch that renders a custom header. Because there is no `appBar:` slot,
/// this page owns its own TOP inset via `SafeArea(bottom: false)` — the
/// BOTTOM inset stays owned by `RootPage`'s tab pill (`root_page.dart`'s doc
/// comment).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Map<String, String> _languageLabels = {
    'en': 'English',
    'ro': 'Română',
    'ru': 'Русский',
    'uk': 'Українська',
    'es': 'Español',
    'de': 'Deutsch',
    'fr': 'Français',
  };

  void _onLanguage(BuildContext context) => LanguageSheet.show(context);

  void _onCurrency(BuildContext context) => CurrencySheet.show(context);

  void _onToggleTheme(BuildContext context) =>
      context.read<SettingsBloc>().add(const SettingsEvent.toggleTheme());

  void _onCategories(BuildContext context) =>
      CategoriesPageRoute().push(context);

  void _onProfile(BuildContext context) => ProfilePageRoute().push(context);

  void _onPrivacy(BuildContext context) => PrivacyPageRoute().push(context);

  void _onAbout(BuildContext context) => AboutPageRoute().push(context);

  /// Sums the current record count across the datasets `DeleteAllRecordsUseCase`
  /// clears, for the confirm dialog's `{n}` — a one-shot read feeding a
  /// dialog's copy, not displayed bloc state, so `getAll()` here is not a
  /// hive_rules.md §9 violation (that rule governs reactive screen state).
  Future<int> _recordCount() async {
    final expenses = await getIt<IExpenseLocalRepository>().getAll();
    final stores = await getIt<IStoreLocalRepository>().getAll();
    final categories = await getIt<ICategoryLocalRepository>().getAll();
    return expenses.length + stores.length + categories.length;
  }

  /// `ConfirmDialog.onConfirm` is a plain `VoidCallback` (it must stay a pure,
  /// synchronous business action per its own doc comment — see
  /// `confirm_dialog.dart`), so the success toast is chained with `.then(...)`
  /// rather than awaited inline; `successMessage` is captured by the caller's
  /// closure, so no mutable field is needed to carry it across the dialog's
  /// lifetime.
  void _onConfirmDeleteAll(String successMessage) {
    getIt<DeleteAllRecordsUseCase>().call().then(
      (_) => UiMessageService.showSuccess(successMessage),
    );
  }

  Future<void> _onDeleteAll(BuildContext context) async {
    final lo = AppLocalizations.of(context);
    final n = await _recordCount();
    if (!context.mounted) return;

    await ConfirmDialog.show(
      context,
      title: lo.deleteAllTitle,
      body: lo.deleteAllBody(n, lo.thisDevice),
      confirmLabel: lo.deleteAllConfirm,
      cancelLabel: lo.cancel,
      onConfirm: () => _onConfirmDeleteAll(lo.tDeletedAll),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) => FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '1.0';

              return SettingsBody(
                state: state,
                languageLabel: state.settings.localeCode == null
                    ? lo.language
                    : (_languageLabels[state.settings.localeCode] ??
                          state.settings.localeCode!),
                currencyLabel: state.settings.currencyCode,
                versionLabel: version,
                onProfile: () => _onProfile(context),
                onCurrency: () => _onCurrency(context),
                onCategories: () => _onCategories(context),
                onLanguage: () => _onLanguage(context),
                onToggleTheme: () => _onToggleTheme(context),
                onDeleteAll: () => _onDeleteAll(context),
                onPrivacy: () => _onPrivacy(context),
                onAbout: () => _onAbout(context),
              );
            },
          ),
        ),
      ),
    );
  }
}

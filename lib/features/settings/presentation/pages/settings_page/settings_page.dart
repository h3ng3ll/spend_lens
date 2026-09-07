import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/scan_capability/e_scan_capability.dart';
import '../../../../../core/services/scan_capability/i_scan_capability_service.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../domain/models/app_settings/e_app_theme_mode.dart';
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
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// Owns the [IScanCapabilityService] re-check via [WidgetsBindingObserver]:
/// permission state can change while the app is backgrounded (the user
/// grants/revokes camera access from OS Settings after tapping "Open
/// Settings"), so the row must re-read on resume rather than caching the
/// value for the page's lifetime.
class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  static const Map<String, String> _languageLabels = {
    'en': 'English',
    'ro': 'Română',
    'ru': 'Русский',
    'uk': 'Українська',
    'es': 'Español',
    'de': 'Deutsch',
    'fr': 'Français',
  };

  late Future<EScanCapability> _scanCapability;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scanCapability = getIt<IScanCapabilityService>().check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _scanCapability = getIt<IScanCapabilityService>().check();
      });
    }
  }

  Future<void> _onOpenScanSettings() async {
    await getIt<IScanCapabilityService>().openAppSettings();
  }

  void _onLanguage(BuildContext context) => LanguageSheet.show(context);

  void _onCurrency(BuildContext context) => CurrencySheet.show(context);

  void _onPickTheme(BuildContext context, EAppThemeMode mode) => context
      .read<SettingsBloc>()
      .add(SettingsEvent.pickTheme(mode: mode));

  void _onCategories(BuildContext context) =>
      CategoriesPageRoute().push(context);

  void _onProfile(BuildContext context) => ProfilePageRoute().push(context);

  void _onPrivacy(BuildContext context) => PrivacyPageRoute().push(context);

  void _onAbout(BuildContext context) => AboutPageRoute().push(context);

  /// `ConfirmDialog.onConfirm` is a plain `VoidCallback` (it must stay a
  /// pure, synchronous business action per its own doc comment — see
  /// `confirm_dialog.dart`), so this only dispatches the delete-all intent
  /// — `SettingsBloc` owns the write, and the success/failure toasts live
  /// in the `BlocListener`s below, never at the dispatch site.
  void _onConfirmDeleteAll(BuildContext context) =>
      context.read<SettingsBloc>().add(const SettingsEvent.deleteAll());

  /// Dispatches `loadRecordCount` and awaits the resolved count via the
  /// bloc's own stream — `SettingsBloc` now owns the three-repository read
  /// that used to be a UI-side `_recordCount()` method calling
  /// `getIt<...Repository>().getAll()` directly.
  Future<int> _recordCount(BuildContext context) async {
    final bloc = context.read<SettingsBloc>();
    bloc.add(const SettingsEvent.loadRecordCount());
    final state = await bloc.stream.firstWhere(
      (state) => state.recordCount != null,
    );
    return state.recordCount!;
  }

  Future<void> _onDeleteAll(BuildContext context) async {
    final lo = AppLocalizations.of(context);
    final n = await _recordCount(context);
    if (!context.mounted) return;

    await ConfirmDialog.show(
      context,
      title: lo.deleteAllTitle,
      body: lo.deleteAllBody(n, lo.thisDevice),
      confirmLabel: lo.deleteAllConfirm,
      cancelLabel: lo.cancel,
      onConfirm: () => _onConfirmDeleteAll(context),
    );
  }

  bool _listenWhenDeleteAllFailed(
    SettingsState previous,
    SettingsState current,
  ) {
    return !previous.isDeleteAllFailed && current.isDeleteAllFailed;
  }

  void _onDeleteAllFailed(BuildContext context, SettingsState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  bool _listenWhenDataCleared(SettingsState previous, SettingsState current) {
    return !previous.settings.dataCleared && current.settings.dataCleared;
  }

  void _onDataCleared(BuildContext context, SettingsState state) =>
      UiMessageService.showSuccess(AppLocalizations.of(context).tDeletedAll);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: _listenWhenDeleteAllFailed,
          listener: _onDeleteAllFailed,
        ),
        // Success is read off the REACTIVE settings stream
        // (`dataCleared` flipping true), not a `.then(...)` chained at the
        // dispatch site — the write is confirmed landed, never assumed.
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: _listenWhenDataCleared,
          listener: _onDataCleared,
        ),
      ],
      child: Scaffold(
        backgroundColor: scheme.bg,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) => FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, packageSnapshot) {
                final version = packageSnapshot.data?.version ?? '1.0';

                return FutureBuilder<EScanCapability>(
                  future: _scanCapability,
                  builder: (context, capabilitySnapshot) {
                    // No `??` fallback: a pending probe stays null so the
                    // row shows "checking", not a fabricated concrete
                    // cause.
                    final capability = capabilitySnapshot.data;

                    return SettingsBody(
                      state: state,
                      languageLabel: state.settings.localeCode == null
                          ? lo.languageSystemDefault
                          : (_languageLabels[state.settings.localeCode] ??
                                state.settings.localeCode!),
                      currencyLabel: state.settings.currencyCode,
                      versionLabel: version,
                      onProfile: () => _onProfile(context),
                      onCurrency: () => _onCurrency(context),
                      onCategories: () => _onCategories(context),
                      onLanguage: () => _onLanguage(context),
                      onPickTheme: (mode) => _onPickTheme(context, mode),
                      onDeleteAll: () => _onDeleteAll(context),
                      onPrivacy: () => _onPrivacy(context),
                      onAbout: () => _onAbout(context),
                      scanCapability: capability,
                      onOpenScanSettings: _onOpenScanSettings,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

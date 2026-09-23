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
import '../../../../auth/presentation/bloc/auth_bloc/auth_bloc.dart';
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

  /// Blocks re-entry while the count read or the confirm dialog is open, so
  /// repeated taps cannot stack dialogs behind each other.
  bool _isDeleteAllOpen = false;

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

  /// Recovers from a non-[EScanCapability.supported] scanning state.
  ///
  /// Prompting is tried FIRST and OS Settings is only the fallback: while the
  /// permission is still askable, sending the user out to Settings is a
  /// needless detour, and on a fresh install it is also misleading — iOS has
  /// no camera row for this app until the native request has actually run
  /// once. `checkOrRequest()` prompts only when the OS says it still can, so
  /// a genuinely blocked permission falls straight through to
  /// `openAppSettings()`.
  Future<void> _onOpenScanSettings() async {
    final capabilityService = getIt<IScanCapabilityService>();
    final capability = await capabilityService.checkOrRequest();

    if (capability != EScanCapability.supported) {
      await capabilityService.openAppSettings();
    }

    if (!mounted) return;
    setState(() {
      _scanCapability = capabilityService.check();
    });
  }

  void _onLanguage(BuildContext context) => LanguageSheet.show(context);

  void _onCurrency(BuildContext context) => CurrencySheet.show(context);

  void _onPickTheme(BuildContext context, EAppThemeMode mode) =>
      context.read<SettingsBloc>().add(SettingsEvent.pickTheme(mode: mode));

  void _onCategories(BuildContext context) =>
      CategoriesPageRoute().push(context);

  void _onProfile(BuildContext context) => ProfilePageRoute().push(context);

  void _onPrivacy(BuildContext context) => PrivacyPageRoute().push(context);

  void _onTerms(BuildContext context) => const TermsPageRoute().push(context);

  void _onAbout(BuildContext context) => AboutPageRoute().push(context);

  /// `ConfirmDialog.onConfirm` is a plain `VoidCallback` (it must stay a
  /// pure, synchronous business action per its own doc comment — see
  /// `confirm_dialog.dart`), so this only dispatches the delete-all intent
  /// — `SettingsBloc` owns the write, and the success/failure toasts live
  /// in the `BlocListener`s below, never at the dispatch site.
  void _onConfirmDeleteAll(BuildContext context) =>
      context.read<SettingsBloc>().add(
        SettingsEvent.deleteAll(uid: context.read<AuthBloc>().state.uid),
      );

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
    if (_isDeleteAllOpen) return;
    if (context.read<SettingsBloc>().state.isDeleteAllRunning) return;
    _isDeleteAllOpen = true;

    try {
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
    } finally {
      _isDeleteAllOpen = false;
    }
  }

  bool _listenWhenDeleteAllFailed(
    SettingsState previous,
    SettingsState current,
  ) {
    return previous.deleteAllStatus != current.deleteAllStatus &&
        current.isDeleteAllFailed;
  }

  void _onDeleteAllFailed(BuildContext context, SettingsState state) =>
      UiMessageService.showError(
        AppLocalizations.of(context).tSaveFailedGeneric,
      );

  bool _listenWhenDeleteAllDone(
    SettingsState previous,
    SettingsState current,
  ) {
    return previous.deleteAllStatus != current.deleteAllStatus &&
        current.isDeleteAllDone;
  }

  void _onDeleteAllDone(BuildContext context, SettingsState state) =>
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
        // Success is read off the bloc's delete-all outcome, not a
        // `.then(...)` at the dispatch site. It used to key on `dataCleared`
        // flipping true, which never flips again once set — so every delete
        // after the first finished silently and looked like it did nothing.
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: _listenWhenDeleteAllDone,
          listener: _onDeleteAllDone,
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
                      onTerms: () => _onTerms(context),
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

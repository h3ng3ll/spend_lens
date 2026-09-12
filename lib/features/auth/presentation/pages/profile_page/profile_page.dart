import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/services/subscription/i_subscription_repository.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../subscription/presentation/sheets/subscription_sheet/subscription_sheet.dart';
import '../../../../sync/presentation/bloc/sync_bloc/sync_bloc.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../../backup/presentation/bloc/backup_bloc/backup_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import 'widgets/profile_body.dart';

/// `ProfilePageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell.
///
/// [AuthBloc] is an app-lifetime, `registerLazySingleton` bloc dispatched
/// once from `main()` (BLoC rule A3.8) — this page reads the EXISTING
/// instance via `context.read`, it never constructs its own.
///
/// [BackupBloc] is SCREEN-scoped (BLoC rule A3.8) — built here in
/// `initState`, closed in `dispose`. Every export/import step (building the
/// JSON/CSV, validating and applying a restore) is real business logic and
/// therefore lives in that bloc, never inline in a widget callback — the UI
/// layer's only jobs are launching the OS file picker / share sheet (system
/// dialogs, not app logic) and reacting to the bloc's status via
/// `BlocListener`.
///
/// The header is drawn entirely by [ProfileBody] (design_spendlens.md's
/// Profile artboard uses its own back control, not the shared
/// `CustomAppBar`), so this page renders no `Scaffold.appBar`.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final BackupBloc _backupBloc;

  @override
  void initState() {
    super.initState();
    _backupBloc = getIt<BackupBloc>();
  }

  @override
  void dispose() {
    _backupBloc.close();
    super.dispose();
  }

  void _onGoogle() =>
      context.read<AuthBloc>().add(const AuthEvent.signInGoogle());

  void _onApple() =>
      context.read<AuthBloc>().add(const AuthEvent.signInApple());

  /// Sign-out now REMOVES data from the device (local copies of records the
  /// server already holds), so it is confirmed first. The dialog states both
  /// halves — what goes and what stays — because "anything not synchronized
  /// is kept" is the reassurance that makes the action safe to accept.
  Future<void> _onSignOut() async {
    final lo = AppLocalizations.of(context);
    final authBloc = context.read<AuthBloc>();

    await ConfirmDialog.show(
      context,
      title: lo.signOutConfirmTitle,
      body: lo.signOutConfirmBody,
      confirmLabel: lo.signOut,
      cancelLabel: lo.cancel,
      onConfirm: () => authBloc.add(const AuthEvent.signOut()),
    );
  }

  void _onExportBackup() => _backupBloc.add(const BackupEvent.exportBackup());

  void _onExportSheet() => _backupBloc.add(const BackupEvent.exportCsv());

  /// The OS file picker is a system dialog, not app business logic — this
  /// stays in the UI layer, but the RESULT is handed straight into the bloc
  /// as an intent event; every subsequent step (read, validate, migrate)
  /// happens inside `BackupBloc`.
  Future<void> _onImportBackup() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    _backupBloc.add(BackupEvent.importFilePicked(files.firstOrNull?.path));
  }

  void _onConfirmImport() => _backupBloc.add(const BackupEvent.confirmImport());

  Future<void> _onShareExportedFile(BackupState state) async {
    final file = state.exportedFile;
    if (file == null) return;
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<void> _onImportReady(BuildContext context, BackupState state) async {
    final lo = AppLocalizations.of(context);
    await ConfirmDialog.show(
      context,
      title: lo.importTitle,
      body: lo.importBody(lo.thisDevice),
      confirmLabel: lo.importConfirm,
      cancelLabel: lo.cancel,
      onConfirm: _onConfirmImport,
    );
  }

  /// Surfaces a failed sign-in.
  ///
  /// Without this the failure was SILENT: `AuthBloc` sets
  /// `EAuthStatus.failed` with a user-facing `errorMessage`, and nothing in
  /// the widget tree read it — the buttons simply did nothing on a real
  /// failure, which is indistinguishable from being unwired.
  ///
  /// A USER CANCELLATION is not an error and must stay quiet: the bloc
  /// already maps it to `signedOut` with an empty message, so gating on a
  /// non-empty message keeps a dismissed Google/Apple sheet from toasting
  /// "sign-in failed" at someone who simply changed their mind.
  void _onAuthListener(BuildContext context, AuthState state) {
    if (state.errorMessage.isEmpty) return;
    UiMessageService.showError(state.errorMessage);
  }

  void _onBackupListener(BuildContext context, BackupState state) {
    final lo = AppLocalizations.of(context);

    if (state.isExportedJson) {
      _onShareExportedFile(state);
      UiMessageService.showSuccess(lo.tBackup(state.exportedFilename));
    } else if (state.isExportedCsv) {
      _onShareExportedFile(state);
      UiMessageService.showSuccess(lo.tCsv(state.exportedRowCount));
    } else if (state.isImportReady) {
      _onImportReady(context, state);
    } else if (state.isImported) {
      UiMessageService.showSuccess(
        lo.tImported(state.importedReceiptCount, state.importedExpenseCount),
      );
    } else if (state.isFailed) {
      UiMessageService.showError(
        switch (state.error) {
          EBackupError.schemaTooNew => lo.importTooNew,
          EBackupError.malformed => lo.importMalformed,
          EBackupError.unexpected || EBackupError.none => lo.importUnexpected,
        },
      );
    }
  }

  /// Opens the in-app premium upgrade sheet.
  ///
  /// Replaces a direct `ISubscriptionRepository.presentPaywall()` call: the
  /// app now owns the plan selection (monthly vs yearly) instead of handing
  /// the whole UI to the SDK, so the user picks a billing period here and
  /// only the purchase itself goes to the repository.
  ///
  /// The sheet reports its own outcome via a toast and closes itself on
  /// success, so this only has to refresh what the rest of Profile shows.
  Future<void> _onUpgrade() async {

    // if (!isPurchaseAvailable) {
    //   UiMessageService.showInfo(
    //     AppLocalizations.of(context).purchasesUnavailable,
    //   );
    //   return;
    // }

    await SubscriptionSheet.show(context);
    if (!mounted) return;

    // Re-sync so the Plan badge and the quota denominator pick up a new
    // entitlement — `hasPremiumAccess()` is a one-shot read by design, so
    // nothing refreshes it on its own. Dispatched unconditionally now: the
    // sheet does not report back whether a purchase landed, and a redundant
    // sync is cheaper than a stale badge.
    context.read<SyncBloc>().add(const SyncEvent.syncNow());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return BlocProvider<BackupBloc>.value(
      value: _backupBloc,
      child: BlocListener<AuthBloc, AuthState>(
        // Fires only on a TRANSITION into a message-bearing state, so a
        // rebuild (theme change, a sync tick) cannot re-toast a stale
        // failure the user already dismissed.
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: _onAuthListener,
        child: BlocListener<BackupBloc, BackupState>(
          listener: _onBackupListener,
          child: Scaffold(
            backgroundColor: scheme.bg,
            body: SafeArea(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) => ProfileBody(
                  state: state,
                  onGoogle: _onGoogle,
                  onApple: _onApple,
                  onSignOut: _onSignOut,
                  onExportBackup: _onExportBackup,
                  onExportSheet: _onExportSheet,
                  onImportBackup: _onImportBackup,
                  isPurchaseAvailable:
                      getIt<ISubscriptionRepository>().isConfigured,
                  onUpgrade: _onUpgrade,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import 'widgets/profile_body.dart';

/// `ProfilePageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell.
///
/// [AuthBloc] is an app-lifetime, `registerLazySingleton` bloc dispatched
/// once from `main()` (BLoC rule A3.8) — this page reads the EXISTING
/// instance via `context.read`, it never constructs its own.
///
/// The header is drawn entirely by [ProfileBody] (design_spendlens.md's
/// Profile artboard uses its own back control, not the shared
/// `CustomAppBar`), so this page renders no `Scaffold.appBar`.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _onGoogle(BuildContext context) =>
      UiMessageService.showInfo(AppLocalizations.of(context).signInComingSoon);

  void _onApple(BuildContext context) =>
      UiMessageService.showInfo(AppLocalizations.of(context).signInComingSoon);

  void _onExportBackup(BuildContext context) =>
      UiMessageService.showInfo(AppLocalizations.of(context).exportComingSoon);

  void _onExportSheet(BuildContext context) =>
      UiMessageService.showInfo(AppLocalizations.of(context).exportComingSoon);

  void _onImportBackup(BuildContext context) =>
      UiMessageService.showInfo(AppLocalizations.of(context).exportComingSoon);

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => ProfileBody(
            state: state,
            onGoogle: () => _onGoogle(context),
            onApple: () => _onApple(context),
            onExportBackup: () => _onExportBackup(context),
            onExportSheet: () => _onExportSheet(context),
            onImportBackup: () => _onImportBackup(context),
          ),
        ),
      ),
    );
  }
}

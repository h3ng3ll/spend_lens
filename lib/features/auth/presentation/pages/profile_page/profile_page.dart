import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import 'widgets/profile_body.dart';

/// `ProfilePageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell.
///
/// [AuthBloc] is an app-lifetime, `registerLazySingleton` bloc dispatched
/// once from `main()` (BLoC rule A3.8) — this page reads the EXISTING
/// instance via `context.read`, it never constructs its own.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.profile)),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) => ProfileBody(state: state),
      ),
    );
  }
}

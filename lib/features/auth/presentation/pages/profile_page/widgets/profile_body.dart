import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';

/// Signed-out / signed-in presentation for `ProfilePage` (M4 minimal
/// placeholder — the real Google/Apple sign-in buttons and account/plan
/// rows are M9).
class ProfileBody extends StatelessWidget {
  final AuthState state;

  const ProfileBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Center(
      child: Text(
        state.isSignedIn ? lo.signedInGoogle : lo.notSignedIn,
        style: textTheme.body17.copyWith(color: scheme.sec),
      ),
    );
  }
}

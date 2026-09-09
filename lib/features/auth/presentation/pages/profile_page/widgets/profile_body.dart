import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';
import 'keep_data_safe_card.dart';
import 'profile_header_row.dart';
import 'profile_identity_column.dart';
import 'signed_in_account_card.dart';
import 'storage_card.dart';
import 'your_data_card.dart';

/// Signed-out / signed-in presentation for `ProfilePage`
/// (design_spendlens.md's Profile artboard, `sc-if notSignedIn` /
/// `sc-if signedIn` blocks). [SignedInAccountCard] carries the
/// `account`/`plan`/`cloudSync`/`signOut` rows the design shows only once
/// signed in.
class ProfileBody extends StatelessWidget {
  final AuthState state;
  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final VoidCallback onSignOut;
  final VoidCallback onExportBackup;
  final VoidCallback onExportSheet;
  final VoidCallback onImportBackup;

  const ProfileBody({
    super.key,
    required this.state,
    required this.onGoogle,
    required this.onApple,
    required this.onSignOut,
    required this.onExportBackup,
    required this.onExportSheet,
    required this.onImportBackup,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            const ProfileHeaderRow(),
            ProfileIdentityColumn(state: state),
            if (state.isNotSignedIn)
              KeepDataSafeCard(
                deviceNoun: lo.thisDevice,
                onGoogle: onGoogle,
                onApple: onApple,
              ),
            if (state.isSignedIn)
              SignedInAccountCard(
                email: state.email,
                onSignOut: onSignOut,
              ),
            StorageCard(deviceNoun: lo.thisDevice, isSignedIn: state.isSignedIn),
            SectionLabel(text: lo.yourData),
            YourDataCard(
              onExportBackup: onExportBackup,
              onExportSheet: onExportSheet,
              onImportBackup: onImportBackup,
            ),
            Text(
              lo.exportNote,
              style: textTheme.footnote13.copyWith(color: scheme.ter),
            ),
          ],
        ),
      ),
    );
  }
}

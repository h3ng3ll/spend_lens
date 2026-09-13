import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/settings_row.dart';

/// The Settings artboard's last grouped card: Privacy, Terms of Use, About
/// (trailing version label, matching the artboard's static "1.0").
///
/// Both legal rows are shown on every platform. `privacy_policy_terms_rules.md`
/// gates Terms behind `if (Platform.isIOS)`, but that gate exists only because
/// `termsOfUseAndroidUrl` does not exist as a config field — this project reads
/// a local asset both platforms can load, so there is no missing input to gate
/// on. See [TermsPage] for the full recorded deviation.
class LegalCard extends StatelessWidget {
  final VoidCallback onPrivacy;
  final VoidCallback onTerms;
  final VoidCallback onAbout;
  final String versionLabel;

  const LegalCard({
    super.key,
    required this.onPrivacy,
    required this.onTerms,
    required this.onAbout,
    required this.versionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsRow(label: lo.privacy, onTap: onPrivacy),
          SettingsRow(label: lo.termsOfUse, onTap: onTerms),
          SettingsRow(
            label: lo.about,
            trailingText: versionLabel,
            showChevron: false,
            showBottomDivider: false,
            onTap: onAbout,
          ),
        ],
      ),
    );
  }
}

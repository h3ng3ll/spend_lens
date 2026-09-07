import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/settings_row.dart';

/// The Settings artboard's last grouped card: Privacy, About (trailing
/// version label, matching the artboard's static "1.0").
class LegalCard extends StatelessWidget {
  final VoidCallback onPrivacy;
  final VoidCallback onAbout;
  final String versionLabel;

  const LegalCard({
    super.key,
    required this.onPrivacy,
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

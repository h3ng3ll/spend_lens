import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/settings_row.dart';

/// Profile artboard's "Your data" card — Export backup / Export spreadsheet
/// / Import backup. Real export/import is `features/backup/`, explicitly
/// M9 (design_spendlens.md's milestone table), so every row here shows an
/// info toast rather than performing a real export.
class YourDataCard extends StatelessWidget {
  final VoidCallback onExportBackup;
  final VoidCallback onExportSheet;
  final VoidCallback onImportBackup;

  const YourDataCard({
    super.key,
    required this.onExportBackup,
    required this.onExportSheet,
    required this.onImportBackup,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsRow(
            label: lo.exportBackup,
            trailingText: 'JSON',
            trailingTextColor: scheme.ter,
            showChevron: false,
            onTap: onExportBackup,
          ),
          SettingsRow(
            label: lo.exportSheet,
            trailingText: 'CSV',
            trailingTextColor: scheme.ter,
            showChevron: false,
            onTap: onExportSheet,
          ),
          SettingsRow(
            label: lo.importBackup,
            showBottomDivider: false,
            onTap: onImportBackup,
          ),
        ],
      ),
    );
  }
}

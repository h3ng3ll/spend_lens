import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/settings_row.dart';

/// The Settings artboard's destructive card — a single "Delete all records"
/// row (`~/.claude/rules/delete_all_records_rules.md`: destructive styling,
/// routed through the shared confirm dialog by the caller).
class DeleteAllCard extends StatelessWidget {
  final VoidCallback onTap;

  const DeleteAllCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SettingsRow(
        label: lo.deleteAll,
        labelColor: scheme.warn,
        showChevron: false,
        showBottomDivider: false,
        onTap: onTap,
      ),
    );
  }
}

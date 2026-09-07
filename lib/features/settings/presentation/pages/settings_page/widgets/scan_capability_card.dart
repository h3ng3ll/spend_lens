import 'package:flutter/material.dart';

import '../../../../../../core/services/scan_capability/e_scan_capability.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import 'scan_capability_row.dart';

/// Its own grouped card (design_spendlens.md §6 mandates this row; the
/// design HTML predates the capability requirement, so no artboard shows
/// it — placed as a standalone card, matching every other grouped-card
/// section on this screen, rather than folding it into an existing card the
/// design DOES show).
class ScanCapabilityCard extends StatelessWidget {
  /// `null` while the probe is in flight; forwarded to [ScanCapabilityRow]
  /// which renders a neutral "checking" state.
  final EScanCapability? capability;
  final VoidCallback onOpenSettings;

  const ScanCapabilityCard({
    super.key,
    required this.capability,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ScanCapabilityRow(
        capability: capability,
        onOpenSettings: onOpenSettings,
      ),
    );
  }
}

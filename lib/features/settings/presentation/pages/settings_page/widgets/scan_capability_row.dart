import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/services/scan_capability/e_scan_capability.dart';
import '../../../../../../core/widgets/settings_row.dart';

/// States the device's scanning-support status directly
/// (design_spendlens.md §6): the Settings screen's half of
/// `IScanCapabilityService`'s two consumers. Never a generic "Something went
/// wrong" — each [EScanCapability] value has its own copy, because "no
/// camera" / "OCR unavailable" are legitimate capability states, not
/// failures.
///
/// On [EScanCapability.permissionPermanentlyDenied] the row exposes an
/// "Open Settings" action — the only recovery path once the OS has
/// permanently blocked the permission prompt.
class ScanCapabilityRow extends StatelessWidget {
  /// `null` while the capability probe is still in flight. Rendered as a
  /// neutral "checking" state — never defaulted to a concrete cause, which
  /// would flash a WRONG status (e.g. "No camera") on a capable device
  /// (recorded bug `absent-data-mapped-to-failed-status`).
  final EScanCapability? capability;
  final VoidCallback onOpenSettings;

  const ScanCapabilityRow({
    super.key,
    required this.capability,
    required this.onOpenSettings,
  });

  String _statusLabel(AppLocalizations lo) => switch (capability) {
    null => lo.scanStatusChecking,
    EScanCapability.supported => lo.scanStatusSupported,
    EScanCapability.noCamera => lo.scanStatusNoCamera,
    EScanCapability.ocrUnavailable => lo.scanStatusOcrUnavailable,
    EScanCapability.permissionDenied => lo.scanStatusPermissionDenied,
    EScanCapability.permissionPermanentlyDenied =>
      lo.scanStatusPermissionPermanentlyDenied,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final isBlocked =
        capability == EScanCapability.permissionPermanentlyDenied;
    // A pending probe is neither good news nor a warning: keep it secondary
    // so an amber "problem" colour never appears for an unknown state.
    final statusColor = switch (capability) {
      null => scheme.sec,
      EScanCapability.supported => scheme.accent2,
      _ => scheme.warn,
    };

    return SettingsRow(
      label: lo.scanningStatus,
      showChevron: false,
      showBottomDivider: false,
      trailing: isBlocked
          ? GestureDetector(
              onTap: onOpenSettings,
              behavior: HitTestBehavior.opaque,
              child: Text(
                lo.openSettings,
                style: textTheme.body17.copyWith(
                  color: scheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Text(
              _statusLabel(lo),
              style: textTheme.body17.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}

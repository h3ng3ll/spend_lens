import 'package:flutter/material.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../../core/services/scan_capability/e_scan_capability.dart';
import '../../../../../../core/services/scan_capability/i_scan_capability_service.dart';
import '../../../../../../core/services/ui_message_service.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../bloc/home_bloc/home_bloc.dart';
import '../../../utils/home_calculations.dart';
import 'home_action_buttons.dart';
import 'home_categories_container.dart';
import 'home_empty_state.dart';
import 'home_header_container.dart';
import 'home_hero_container.dart';
import 'home_recent_container.dart';

/// Populated / truly-empty presentation for `HomePage`
/// (design_spendlens.md — Home artboard, combined with the v1 "Empty state"
/// component for the zero-expenses-anywhere case).
class HomeBody extends StatelessWidget {
  final HomeState state;

  const HomeBody({super.key, required this.state});

  /// design_spendlens.md §6: reads the ONE `IScanCapabilityService` source —
  /// the Settings screen's capability row reads the same service. Tapping
  /// Scan Receipt when the device is not [EScanCapability.supported] shows
  /// a per-state toast naming the ACTUAL reason (no camera / OCR
  /// unavailable / permission denied / permanently denied) and never
  /// navigates; on [EScanCapability.permissionDenied] it requests the
  /// permission inline first, since that state is still recoverable without
  /// leaving the app.
  Future<void> _onScanReceipt(BuildContext context) async {
    final lo = AppLocalizations.of(context);
    final capabilityService = getIt<IScanCapabilityService>();

    var capability = await capabilityService.check();
    if (capability == EScanCapability.permissionDenied) {
      capability = await capabilityService.requestPermission();
    }

    if (capability == EScanCapability.supported) {
      if (!context.mounted) return;
      const ScannerPageRoute().push(context);
      return;
    }

    final message = switch (capability) {
      EScanCapability.noCamera => lo.scanUnsupportedNoCamera,
      EScanCapability.ocrUnavailable => lo.scanUnsupportedOcrUnavailable,
      EScanCapability.permissionDenied => lo.scanUnsupportedPermissionDenied,
      EScanCapability.permissionPermanentlyDenied =>
        lo.scanUnsupportedPermissionPermanentlyDenied,
      EScanCapability.unavailable => lo.scanUnsupportedUnavailable,
      EScanCapability.supported => lo.scanUnsupportedNoCamera, // unreachable
    };
    await UiMessageService.showInfo(message);
  }

  void _onAddCashExpense(BuildContext context) =>
      const CashExpensePageRoute().push(context);

  @override
  Widget build(BuildContext context) {
    final snapshot = state.snapshot;

    if (snapshot == null || isHomeTrulyEmpty(snapshot)) {
      return Center(
        child: HorizontalPadding(
          child: HomeEmptyState(
            onScanFirstReceipt: () => _onScanReceipt(context),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20.0,
          children: [
            const HomeHeaderContainer(),
            HomeHeroContainer(snapshot: snapshot),
            HomeActionButtons(
              scanIconAsset: AppIcons.scanFrame,
              onScanReceipt: () => _onScanReceipt(context),
              onAddCashExpense: () => _onAddCashExpense(context),
            ),
            HomeCategoriesContainer(snapshot: snapshot),
            HomeRecentContainer(snapshot: snapshot),
          ],
        ),
      ),
    );
  }
}

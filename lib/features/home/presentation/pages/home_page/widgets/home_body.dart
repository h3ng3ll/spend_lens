import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
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

  void _onScanReceipt(BuildContext context) {
    // M5 ships no scanner (M7/M8) — the button is real, its destination
    // isn't yet, so it surfaces that honestly via a toast instead of
    // pretending to navigate somewhere.
    final lo = AppLocalizations.of(context);
    UiMessageService.showInfo(lo.scanComingSoon);
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

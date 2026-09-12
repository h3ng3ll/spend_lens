import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/utils/app_limits.dart';
import '../../../../../core/widgets/app_container.dart';
import '../../../../../core/widgets/gradient_cta_button.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../domain/models/subscription/subscription_offer.dart';
import '../../../domain/use_cases/get_offers_use_case.dart';
import '../../../domain/use_cases/purchase_subscription_use_case.dart';
import '../../../domain/use_cases/restore_purchases_use_case.dart';
import '../../bloc/subscription_bloc/subscription_bloc.dart';
import 'widgets/plan_option_card.dart';
import 'widgets/premium_feature_row.dart';
import 'widgets/restore_purchase_button.dart';

/// The premium upgrade sheet — a bottom sheet, NOT a route, opened from
/// Profile's `UpgradeToPremiumButton`.
///
/// Presented on the ROOT navigator (`useRootNavigator: true`) so the 5-tab
/// bottom bar does not paint over its scrim — see `CurrencySheet.show`.
///
/// **Purchases do not work yet, by design.** The sheet, its bloc, and the
/// two use cases it dispatches into are wired end-to-end; the repository
/// behind them (`ApphudSubscriptionRepository.purchasePlan` /
/// `restorePurchases`) is an explicit stub that reports "not entitled".
/// Subscribing therefore shows the unavailable-purchases toast rather than
/// silently doing nothing — a control that looks live and does nothing on
/// tap is the defect this codebase repeatedly calls out.
class SubscriptionSheet extends StatelessWidget {
  const SubscriptionSheet({super.key});

  /// Opens the sheet, building its screen-scoped [SubscriptionBloc].
  ///
  /// The bloc is created here rather than in `main()` (BLoC rule A3.8) and
  /// is closed by `BlocProvider` when the sheet's route is popped.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      // Root navigator, above the 5-tab shell — see `CurrencySheet.show`.
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider<SubscriptionBloc>(
        create: (_) =>
            SubscriptionBloc(
              purchaseSubscription: getIt<PurchaseSubscriptionUseCase>(),
              restorePurchases: getIt<RestorePurchasesUseCase>(),
              getOffersUseCase: getIt<GetOffersUseCase>(),
            )..add(
              SubscriptionEvent.getOffers(),
            ),
        child: const SubscriptionSheet(),
      ),
    );
  }

  void _onSelectPlan(
    BuildContext context,
    SubscriptionOffer offer,
  ) => context.read<SubscriptionBloc>().add(
    SubscriptionEvent.selectPlan(
      offer.id,
    ),
  );

  void _onSubscribe(BuildContext context) =>
      context.read<SubscriptionBloc>().add(const SubscriptionEvent.purchase());

  void _onRestore(BuildContext context) =>
      context.read<SubscriptionBloc>().add(const SubscriptionEvent.restore());

  bool _listenWhenOutcome(
    SubscriptionState previous,
    SubscriptionState current,
  ) {
    return previous.status != current.status;
  }

  /// Reports the outcome of a finished purchase/restore attempt.
  ///
  /// `nothingToRestore` gets its own honest copy rather than the error
  /// toast: nothing went wrong, there was simply no prior purchase
  /// (recorded bug `absent-data-mapped-to-failed-status`).
  void _onOutcome(BuildContext context, SubscriptionState state) {
    final lo = AppLocalizations.of(context);

    if (state.isEntitled) {
      UiMessageService.showSuccess(
        lo.tPremiumOn(AppLimits.premiumCloudQuotaLabel),
      );
      Navigator.of(context).pop();
      return;
    }

    if (state.isNothingToRestore) {
      UiMessageService.showInfo(lo.premiumRestoreNothing);
      return;
    }

    if (state.isFailed) {
      UiMessageService.showInfo(lo.purchasesUnavailable);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);
    final quota = AppLimits.premiumCloudQuotaLabel;

    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listenWhen: _listenWhenOutcome,
      listener: _onOutcome,
      child: SafeArea(
        child: AppContainer(
          color: scheme.sheet,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24.0),
          ),
          child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
            builder: (context, state) {
              final isBusy = state.isBusy;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: HorizontalPadding(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16.0,
                      children: [
                        Center(
                          child: AppContainer(
                            width: 36.0,
                            height: 5.0,
                            borderRadius: BorderRadius.circular(3.0),
                            color: scheme.dim,
                          ),
                        ),
                        Text(
                          lo.premiumUpgradeTitle,
                          textAlign: TextAlign.center,
                          style: textTheme.screenTitle28.copyWith(
                            color: scheme.ink,
                          ),
                        ),
                        Text(
                          lo.premiumUpgradeSubtitle(quota),
                          textAlign: TextAlign.center,
                          style: textTheme.subhead15.copyWith(
                            color: scheme.sec,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10.0,
                          children: [
                            PremiumFeatureRow(
                              label: lo.premiumFeatureHistory,
                            ),
                            PremiumFeatureRow(label: lo.premiumFeatureSync),
                            PremiumFeatureRow(
                              label: lo.premiumFeatureStorage(quota),
                            ),
                          ],
                        ),
                        ...state.subscriptions.map(
                          (e) {
                            return PlanOptionCard(
                              title: e.name,
                              price: e.price,
                              // note: lo.planYearlyNote,
                              badge: lo.planBestValue,
                              selected: state.selectedPlan == e.id,
                              onTap: () => _onSelectPlan(
                                context,
                                e,
                              ),
                            );
                          },
                        ),
                        // PlanOptionCard(
                        //   title: lo.planYearly,
                        //   price: lo.planYearlyPrice,
                        //   note: lo.planYearlyNote,
                        //   badge: lo.planBestValue,
                        //   selected:
                        //       state.selectedPlan == ESubscriptionPlan.yearly,
                        //   onTap: () => _onSelectYearly(context),
                        // ),
                        // PlanOptionCard(
                        //   title: lo.planMonthly,
                        //   price: lo.planMonthlyPrice,
                        //   selected:
                        //       state.selectedPlan == ESubscriptionPlan.monthly,
                        //   onTap: () => _onSelectMonthly(context),
                        // ),
                        GradientCtaButton(
                          label: lo.premiumSubscribe,
                          enabled: !isBusy,
                          onTap: () => _onSubscribe(context),
                        ),
                        RestorePurchaseButton(
                          label: lo.premiumRestore,
                          enabled: !isBusy,
                          onTap: () => _onRestore(context),
                        ),
                        Text(
                          lo.premiumTerms,
                          textAlign: TextAlign.center,
                          style: textTheme.footnote13.copyWith(
                            color: scheme.ter,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

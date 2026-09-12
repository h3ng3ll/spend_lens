import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../features/subscription/domain/failures/subscription_failures.dart';
import '../../../features/subscription/domain/models/subscription/subscription_offer.dart';
import '../../../features/subscription/presentation/bloc/subscription_bloc/subscription_bloc.dart';
import '../../utils/env/env.dart';
import '../logger_service.dart';
import 'i_subscription_repository.dart';

class RevenueCatSubscriptionRepository implements ISubscriptionRepository {
  final LoggerService _loggerService;
  bool _started = false;
  bool _hasPro = false;
  final _proEntitlementKey = 'hengell_pro';

  RevenueCatSubscriptionRepository({
    required this._loggerService,
  });

  @override
  Future<void> init(Env env) async {
    if (_started) {
      _loggerService.info(
        'RevenueCatSubscriptionRepository: already initialized skip ...',
      );
      return;
    }
    if (env.revenueCatKey.isEmpty) {
      _loggerService.info(
        'RevenueCatSubscriptionRepository: REVENUE_CAT_KEY is empty — '
        'subscription checks are disabled until .env is configured.',
      );
      return;
    }
    try {
      await Purchases.setLogLevel(LogLevel.verbose);

      await Purchases.configure(
        PurchasesConfiguration(
          env.revenueCatKey,
        ),
      );
      _started = true;
      // CustomerInfo ci = await Purchases.getCustomerInfo();
      // final hasPro = ci.entitlements.active.containsKey('hengell_pro');
    } catch (error) {
      _loggerService.info(
        'Failed to configure Purchases.configure() , RevenueCat',
      );
    }
  }

  @override
  Future<bool> hasPremiumAccess() async {
    final ci = await Purchases.getCustomerInfo();
    _hasPro = ci.entitlements.active.containsKey(
      'hengell_pro',
    );
    return _hasPro;
  }

  @override
  bool get isConfigured => _started;

  /// Return true if paywall were purchased
  @override
  Future<bool> presentPaywall() async {
    final paywallResult = await RevenueCatUI.presentPaywall();
    return paywallResult == .purchased;
  }

  @override
  PurchaseHandlingType purchasePlan(
    String planId,
  ) async {
    try {
      final Offerings offerings = await Purchases.getOfferings();

      final offering = offerings.current;
      if (offering == null) {
        _loggerService.warning(
          'No subscriptions found',
        );
        return Right(
          NoSubscriptionsFound(),
        );
      }
      final Package package = offering.availablePackages.firstWhere(
        (e) => e.storeProduct.identifier == planId,
      );

      final PurchaseResult res = await Purchases.purchase(
        PurchaseParams.package(package),
      );

      // Purchases.purchase(PurchaseParams.subscriptionOption(package.presentedOfferingContext))
      final containEntitlement = res.customerInfo.entitlements.all.containsKey(
        _proEntitlementKey,
      );
      _loggerService.info(
        'After Purchase entitlements: $containEntitlement',
      );
      return Left(
        containEntitlement
            ? ESubscriptionStatus.purchased
            : ESubscriptionStatus.failed,
      );
    } on PlatformException catch (err) {
      return Right(
        FailedPurchaseFailure(
          details: err.message ?? err.details.toString(),
        ),
      );
    } catch (err) {
      return Right(
        FailedPurchaseFailure(
          details: err.toString(),
        ),
      );
    }
  }

  @override
  PurchaseHandlingType restorePurchases() async {
    try {
      CustomerInfo ci = await Purchases.getCustomerInfo();
      final isContainKey = ci.entitlements.active.containsKey(
        _proEntitlementKey,
      );
      return Left(
        isContainKey
            ? ESubscriptionStatus.restored
            : ESubscriptionStatus.nothingToRestore,
      );
    } catch (err) {
      _loggerService.error(
        'Failed to restore purchase $err',
      );
      return Right(
        UnknownSubscriptionFailure(),
      );
    }
  }

  @override
  Future<Either<List<SubscriptionOffer>, SubscriptionFailures>>
  getSubscriptionOffers() async {
    final Offerings offerings = await Purchases.getOfferings();

    final offering = offerings.current;
    if (offering == null) {
      _loggerService.warning(
        'No subscriptions found',
      );
      return Right(
        NoSubscriptionsFound(),
      );
    }

    final subscriptionOffer = offering.availablePackages.map(
      (e) {
        final subscriptionId = e.identifier;
        print(subscriptionId);
        return SubscriptionOffer(
          id: e.storeProduct.identifier,
          name: e.storeProduct.title,
          description: e.storeProduct.description,
          price: e.storeProduct.priceString,
        );
      },
    ).toList();

    return Left(
      subscriptionOffer,
    );
  }
}

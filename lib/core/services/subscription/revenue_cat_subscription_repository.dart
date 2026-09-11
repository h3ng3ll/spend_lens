import 'package:dartz/dartz.dart';
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
      CustomerInfo ci = await Purchases.getCustomerInfo();
      final hasPro = ci.entitlements.active.containsKey('hengell_pro');
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
  // TODO: implement isConfigured
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
    // TODO: implement restorePurchases
    throw UnimplementedError();
    // CustomerInfo ci = await Purchases.getCustomerInfo();
    // final hasPro = ci.entitlements.active.containsKey('hengell_pro');
    // final offerings = await Purchases.getOfferings();
    // final current = offerings.current;
    // print(current);
    // return false;
  }

  @override
  PurchaseHandlingType
  restorePurchases() async {
    // TODO: implement restorePurchases
    throw UnimplementedError();
  }

  @override
  Future<Either<List<SubscriptionOffer>, SubscriptionFailures>>
  getSubscriptionOffers() {
    // TODO: implement getSubscriptionOffers
    throw UnimplementedError();
  }
}

import '../../../../core/services/subscription/i_subscription_repository.dart';

/// Restores a previously-purchased premium entitlement.
///
/// App Review requires a restore path in any app selling a subscription, so
/// this is not optional polish — a sheet that can only BUY is a rejection.
///
/// Backed by the same stub as [PurchaseSubscriptionUseCase]; see that class
/// for why `false` is a complete answer today.
class RestorePurchasesUseCase {
  final ISubscriptionRepository _subscriptionRepository;

  const RestorePurchasesUseCase(this._subscriptionRepository);

  /// Returns whether the user ended up entitled. Never throws.
  Future<bool> call() {
    return _subscriptionRepository.restorePurchases();
  }
}

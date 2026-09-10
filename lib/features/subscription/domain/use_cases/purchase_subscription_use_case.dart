import '../../../../core/services/subscription/i_subscription_repository.dart';
import '../models/e_subscription_plan.dart';

/// Buys the premium subscription for one billing period.
///
/// A use case rather than a direct repository call from the bloc because
/// the purchase is domain policy, not presentation: which entitlement a
/// plan grants, and what "the purchase succeeded" means, belong here rather
/// than in a widget's callback.
///
/// The repository behind this is a STUB at present
/// (`ApphudSubscriptionRepository.purchasePlan` logs and returns false), so
/// this always reports "not entitled" today. That is deliberate and the
/// contract is unchanged by it: `false` already means "the user did not end
/// up entitled", which is also what a cancelled purchase returns, so no
/// caller needs to know the difference.
class PurchaseSubscriptionUseCase {
  final ISubscriptionRepository _subscriptionRepository;

  const PurchaseSubscriptionUseCase(this._subscriptionRepository);

  /// Returns whether the user ended up entitled. Never throws — see
  /// [ISubscriptionRepository.purchasePlan].
  Future<bool> call(ESubscriptionPlan plan) {
    return _subscriptionRepository.purchasePlan(plan);
  }
}

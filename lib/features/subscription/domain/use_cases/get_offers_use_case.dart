import 'package:dartz/dartz.dart';

import '../../../../core/services/subscription/i_subscription_repository.dart';
import '../failures/subscription_failures.dart';
import '../models/subscription/subscription_offer.dart';


class GetOffersUseCase {
  final ISubscriptionRepository _subscriptionRepository;

  const GetOffersUseCase(this._subscriptionRepository);

  Future<Either<List<SubscriptionOffer>, SubscriptionFailures>> call() {
    return _subscriptionRepository.getSubscriptionOffers();
  }
}

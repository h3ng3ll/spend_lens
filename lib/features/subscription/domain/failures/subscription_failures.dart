import '../../../../core/failures/failure.dart';

abstract class SubscriptionFailures extends Failure {
  SubscriptionFailures(super.message);
}

class AlreadyInitializedSubscriptionFailure implements SubscriptionFailures {
  @override
  String get message => 'Already initialized';
}

class TimeoutSubscriptionFailure implements SubscriptionFailures {
  final String timeout;

  TimeoutSubscriptionFailure({
    required this.timeout,
  });

  @override
  String get message => 'Time out exceeded . Try again';
}

class UnknownSubscriptionFailure implements SubscriptionFailures {
  @override
  String get message => 'Something went wrong . try again';
}

class FailedPurchaseFailure implements SubscriptionFailures {
  final String details;

  FailedPurchaseFailure({
    required this.details,
  });

  @override
  String get message => 'Failed purchase , details: $details';
}

class RestorePurchaseFailure implements SubscriptionFailures {
  final String details;

  RestorePurchaseFailure({
    required this.details,
  });

  @override
  String get message => 'Failed to restore purchase , details: $details';
}

class NoSubscriptionsFound implements SubscriptionFailures {
  @override
  String get message => 'No subscriptions found';
}

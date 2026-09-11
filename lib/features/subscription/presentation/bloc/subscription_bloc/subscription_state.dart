part of 'subscription_bloc.dart';

enum ESubscriptionStatus {
  idle,
  loading,
  purchasing,
  loaded,

  /// The purchase completed and the user is entitled.
  purchased,
  restoring,

  /// A restore completed and found an entitlement.
  restored,

  /// A restore completed and found nothing to restore. Distinct from
  /// [failed]: nothing went wrong, there was simply no prior purchase, and
  /// telling the user "something went wrong" for that is the recorded bug
  /// `absent-data-mapped-to-failed-status`.
  nothingToRestore,
  failed,
}

@freezed
sealed class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default(ESubscriptionStatus.idle) ESubscriptionStatus status,

    /// Id
    String? selectedPlan,
    @Default([]) List<SubscriptionOffer> subscriptions,
    @Default('') String errorMessage,
  }) = _SubscriptionState;
}

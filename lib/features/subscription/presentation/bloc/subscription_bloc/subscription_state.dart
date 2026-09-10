part of 'subscription_bloc.dart';

enum ESubscriptionStatus {
  idle,
  purchasing,

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

    /// Defaults to yearly — the sheet presents it as the better-value
    /// option, so it is also the one pre-selected.
    @Default(ESubscriptionPlan.yearly) ESubscriptionPlan selectedPlan,
  }) = _SubscriptionState;
}

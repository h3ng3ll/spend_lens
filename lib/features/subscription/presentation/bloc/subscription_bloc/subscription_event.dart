part of 'subscription_bloc.dart';

/// Intent events (BLoC rule A3.7) — the UI dispatches these and never reads
/// state to choose between them.
@freezed
sealed class SubscriptionEvent with _$SubscriptionEvent {
  /// The user tapped one of the plan cards.
  const factory SubscriptionEvent.selectPlan(ESubscriptionPlan plan) =
      _SelectPlan;

  /// The user tapped the CTA. Deliberately payload-free — the plan to buy
  /// is `SubscriptionState.selectedPlan`, so the UI cannot hand the bloc a
  /// different one than the highlight shows.
  const factory SubscriptionEvent.purchase() = _Purchase;

  const factory SubscriptionEvent.restore() = _Restore;
}

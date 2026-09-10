part of 'subscription_bloc.dart';

/// The UI reads these getters, never the enum directly.
extension SubscriptionStateX on SubscriptionState {
  bool get isIdle => status == ESubscriptionStatus.idle;

  /// An SDK call is in flight. Aliases [isBusy] rather than naming one of
  /// the two actions: both block the sheet's controls identically, and the
  /// project's state-ext contract requires an `isLoading` on every bloc.
  bool get isLoading => isBusy;

  bool get isPurchasing => status == ESubscriptionStatus.purchasing;

  bool get isPurchased => status == ESubscriptionStatus.purchased;

  bool get isRestoring => status == ESubscriptionStatus.restoring;

  bool get isRestored => status == ESubscriptionStatus.restored;

  bool get isNothingToRestore =>
      status == ESubscriptionStatus.nothingToRestore;

  bool get isFailed => status == ESubscriptionStatus.failed;

  /// Either action is in flight — the sheet disables both controls so a
  /// second tap cannot start a concurrent purchase.
  bool get isBusy => isPurchasing || isRestoring;

  /// The user ended up entitled by either route, which is what closes the
  /// sheet.
  bool get isEntitled => isPurchased || isRestored;

  /// A purchase or restore finished and the user is now premium — this
  /// bloc's terminal success state.
  bool get isSuccess => isEntitled;
}

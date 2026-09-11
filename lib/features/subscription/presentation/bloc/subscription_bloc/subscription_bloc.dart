import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/subscription/subscription_offer.dart';
import '../../../domain/use_cases/get_offers_use_case.dart';
import '../../../domain/use_cases/purchase_subscription_use_case.dart';
import '../../../domain/use_cases/restore_purchases_use_case.dart';

part 'subscription_event.dart';

part 'subscription_state.dart';

part 'subscription_state_ext.dart';

part 'subscription_bloc.freezed.dart';

/// Screen-scoped bloc (`registerFactory` semantics: built by
/// `SubscriptionSheet.show`, closed when the sheet's route is popped —
/// never registered in `main()`, per BLoC rule A3.8).
///
/// Holds the upgrade sheet's whole interaction: which billing period is
/// selected, and the outcome of the purchase/restore attempt. There is no
/// reactive read here — entitlement is a one-shot SDK check by design (see
/// [ISubscriptionRepository]), not a Hive box something else can mutate
/// underneath this sheet, so hive_rules.md §6's `watchAll()` requirement
/// does not apply.
///
/// The use cases it calls are real; the REPOSITORY behind them is a stub
/// that always reports "not entitled". So `purchase` and `restore` run
/// their full state machine and land on [ESubscriptionStatus.failed] today.
/// That is the intended state of this slice — the events, the use cases and
/// the wiring exist so that implementing the SDK call is the only remaining
/// step.
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final PurchaseSubscriptionUseCase _purchaseSubscription;
  final RestorePurchasesUseCase _restorePurchases;
  final GetOffersUseCase _getOffersUseCase;

  SubscriptionBloc({
    required this._purchaseSubscription,
    required this._restorePurchases,
    required this._getOffersUseCase,
  }) : super(const SubscriptionState()) {
    on<_SelectPlan>(_onSelectPlan);
    on<_Purchase>(_onPurchase);
    on<_Restore>(_onRestore);
    on<_GetOffers>(_getOffers);
  }

  /// Pure selection — no purchase happens until the CTA is tapped, so this
  /// only moves the highlight and clears any previous failure so a retry
  /// does not render under a stale error.
  void _onSelectPlan(_SelectPlan event, Emitter<SubscriptionState> emit) {
    emit(
      state.copyWith(
        selectedPlan: event.planId,
        status: ESubscriptionStatus.idle,
      ),
    );
  }

  /// Buys [SubscriptionState.selectedPlan].
  ///
  /// Carries NO payload: the selected plan already lives in state, and an
  /// event that re-sent it would let the UI and the bloc disagree about
  /// what is being bought (BLoC rule — the UI dispatches intent, never
  /// state it read back out).
  Future<void> _onPurchase(
    _Purchase event,
    Emitter<SubscriptionState> emit,
  ) async {
    if (state.isPurchasing || state.selectedPlan == null) {
      return;
    }

    emit(
      state.copyWith(
        status: ESubscriptionStatus.purchasing,
      ),
    );

    final res = await _purchaseSubscription(
      state.selectedPlan!,
    );
    res.fold(
      (status) {
        emit(
          state.copyWith(
            status: status,
          ),
        );
      },
      (err) {
        emit(
          state.copyWith(
            status: .failed,
            errorMessage: err.message,
          ),
        );
      },
    );
  }

  Future<void> _getOffers(
    _GetOffers event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: .loading,
      ),
    );
    final res = await _getOffersUseCase.call();

    res.fold(
      (subscriptions) {
        emit(
          state.copyWith(
            subscriptions: subscriptions,
            status: .loaded,
          ),
        );
      },
      (e) {
        emit(
          state.copyWith(
            errorMessage: e.message,
            status: .failed,
          ),
        );
      },
    );
  }

  Future<void> _onRestore(
    _Restore event,
    Emitter<SubscriptionState> emit,
  ) async {
    if (state.isRestoring) return;

    emit(
      state.copyWith(
        status: ESubscriptionStatus.restoring,
      ),
    );

    final res = await _restorePurchases();
    res.fold(
      (status) {
        emit(
          state.copyWith(
            status: status,
          ),
        );
      },
      (err) {
        emit(
          state.copyWith(
            status: .failed,
          ),
        );
      },
    );
  }
}

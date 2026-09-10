import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/services/subscription/i_subscription_repository.dart';
import 'package:spend_lens/features/subscription/domain/models/e_subscription_plan.dart';
import 'package:spend_lens/features/subscription/domain/use_cases/purchase_subscription_use_case.dart';
import 'package:spend_lens/features/subscription/domain/use_cases/restore_purchases_use_case.dart';
import 'package:spend_lens/features/subscription/presentation/bloc/subscription_bloc/subscription_bloc.dart';

/// The premium upgrade sheet's bloc.
///
/// The repository is a STUB today (always "not entitled"), so these tests
/// drive a fake instead — they pin the bloc's contract so that swapping the
/// real SDK call in behind the use cases is the only remaining work.
void main() {
  late _FakeSubscriptionRepository repository;

  SubscriptionBloc buildBloc() => SubscriptionBloc(
        purchaseSubscription: PurchaseSubscriptionUseCase(repository),
        restorePurchases: RestorePurchasesUseCase(repository),
      );

  setUp(() => repository = _FakeSubscriptionRepository());

  test('defaults to the yearly plan', () {
    expect(buildBloc().state.selectedPlan, ESubscriptionPlan.yearly);
  });

  test('selectPlan moves the selection without purchasing', () async {
    final bloc = buildBloc()
      ..add(const SubscriptionEvent.selectPlan(ESubscriptionPlan.monthly));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.selectedPlan, ESubscriptionPlan.monthly);
    expect(bloc.state.isIdle, isTrue);
    expect(
      repository.purchasedPlans,
      isEmpty,
      reason: 'Selecting a plan must not start a purchase — only the CTA does.',
    );

    await bloc.close();
  });

  test('purchase buys the SELECTED plan', () async {
    repository.purchaseResult = true;

    final bloc = buildBloc()
      ..add(const SubscriptionEvent.selectPlan(ESubscriptionPlan.monthly))
      ..add(const SubscriptionEvent.purchase());
    await Future<void>.delayed(Duration.zero);

    expect(repository.purchasedPlans, [ESubscriptionPlan.monthly]);
    expect(bloc.state.isPurchased, isTrue);
    expect(bloc.state.isEntitled, isTrue);

    await bloc.close();
  });

  test('a declined purchase fails rather than reporting entitlement',
      () async {
    repository.purchaseResult = false;

    final bloc = buildBloc()..add(const SubscriptionEvent.purchase());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.isFailed, isTrue);
    expect(bloc.state.isEntitled, isFalse);

    await bloc.close();
  });

  test('a restore that finds nothing is NOT reported as a failure', () async {
    // `absent-data-mapped-to-failed-status` — "no prior purchase" is a
    // normal outcome, and showing "something went wrong" for it is the bug.
    repository.restoreResult = false;

    final bloc = buildBloc()..add(const SubscriptionEvent.restore());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.isNothingToRestore, isTrue);
    expect(bloc.state.isFailed, isFalse);

    await bloc.close();
  });

  test('a successful restore entitles the user', () async {
    repository.restoreResult = true;

    final bloc = buildBloc()..add(const SubscriptionEvent.restore());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.isRestored, isTrue);
    expect(bloc.state.isEntitled, isTrue);

    await bloc.close();
  });

  test('a second purchase tap while one is in flight is ignored', () async {
    repository.purchaseDelay = const Duration(milliseconds: 20);
    repository.purchaseResult = true;

    final bloc = buildBloc()
      ..add(const SubscriptionEvent.purchase())
      ..add(const SubscriptionEvent.purchase());
    await Future<void>.delayed(const Duration(milliseconds: 60));

    expect(
      repository.purchasedPlans,
      hasLength(1),
      reason: 'Double-tapping the CTA must not start two SDK purchases.',
    );

    await bloc.close();
  });

  test('a thrown repository error surfaces as failed, not an exception',
      () async {
    repository.shouldThrow = true;

    final bloc = buildBloc()..add(const SubscriptionEvent.purchase());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.isFailed, isTrue);

    await bloc.close();
  });
}

class _FakeSubscriptionRepository implements ISubscriptionRepository {
  final List<ESubscriptionPlan> purchasedPlans = [];
  bool purchaseResult = false;
  bool restoreResult = false;
  bool shouldThrow = false;
  Duration purchaseDelay = Duration.zero;

  @override
  Future<bool> purchasePlan(ESubscriptionPlan plan) async {
    if (shouldThrow) throw Exception('sdk exploded');
    if (purchaseDelay > Duration.zero) {
      await Future<void>.delayed(purchaseDelay);
    }
    purchasedPlans.add(plan);
    return purchaseResult;
  }

  @override
  Future<bool> restorePurchases() async {
    if (shouldThrow) throw Exception('sdk exploded');
    return restoreResult;
  }

  @override
  Future<bool> hasPremiumAccess() async => false;

  @override
  Future<bool> presentPaywall() async => false;

  @override
  bool get isConfigured => true;
}

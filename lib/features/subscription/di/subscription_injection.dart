import '../../../core/di/injection.dart';
import '../../../core/services/subscription/i_subscription_repository.dart';
import '../domain/use_cases/purchase_subscription_use_case.dart';
import '../domain/use_cases/restore_purchases_use_case.dart';

/// Registers the premium-upgrade slice's use cases.
///
/// The repository itself is registered in `core/di/injection.dart` (it is a
/// core service, shared with Profile and the sync slice); only the two use
/// cases this feature owns live here.
void initSubscriptionFeature() {
  getIt.registerLazySingleton(
    () => PurchaseSubscriptionUseCase(getIt<ISubscriptionRepository>()),
  );
  getIt.registerLazySingleton(
    () => RestorePurchasesUseCase(getIt<ISubscriptionRepository>()),
  );
}

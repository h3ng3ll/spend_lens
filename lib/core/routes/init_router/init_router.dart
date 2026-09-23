import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/analytics/presentation/pages/analytics_page/analytics_page.dart';
import '../../../features/analytics/presentation/pages/price_history_page/price_history_page.dart';
import '../../../features/auth/presentation/pages/edit_profile_page/edit_profile_page.dart';
import '../../../features/auth/presentation/pages/profile_page/profile_page.dart';
import '../../../features/category/presentation/pages/category_page/category_page.dart';
import '../../../features/category/presentation/pages/new_category_page/new_category_page.dart';
import '../../../features/expense/presentation/pages/cash_expense_page/cash_expense_page.dart';
import '../../../features/history/presentation/pages/history_page/history_page.dart';
import '../../../features/history/presentation/pages/record_detail_page/record_detail_page.dart';
import '../../../features/home/presentation/pages/home_page/home_page.dart';
import '../../../features/onboarding/presentation/pages/onboarding_page/onboarding_page.dart';
import '../../../features/receipt/presentation/pages/edit_receipt_page/edit_receipt_page.dart';
import '../../../features/receipt/presentation/pages/receipt_photo_page/receipt_photo_page.dart';
import '../../../features/receipt/presentation/pages/receipt_storage_page/receipt_storage_page.dart';
import '../../../features/receipt/presentation/pages/review_page/review_page.dart';
import '../../../features/scanner/presentation/pages/scanner_page/scanner_page.dart';
import '../../../features/settings/presentation/pages/about_page/about_page.dart';
import '../../../features/settings/presentation/pages/privacy_page/privacy_page.dart';
import '../../../features/settings/presentation/pages/terms_page/terms_page.dart';
import '../../../features/settings/presentation/pages/settings_page/settings_page.dart';
import '../../../features/product/presentation/pages/choose_product_page/choose_product_page.dart';
import '../../../features/product/presentation/pages/edit_product_page/edit_product_page.dart';
import '../../../features/product/presentation/pages/new_product_page/new_product_page.dart';
import '../../../features/product/presentation/pages/product_detail_page/product_detail_page.dart';
import '../../../features/store/presentation/pages/choose_store_page/choose_store_page.dart';
import '../../../features/store/presentation/pages/edit_store_page/edit_store_page.dart';
import '../../../features/store/presentation/pages/new_store_page/new_store_page.dart';
import '../../../features/store/presentation/pages/store_detail_page/store_detail_page.dart';
import '../../../features/store/presentation/pages/store_page/store_page.dart';
import '../presentation/loading_data_widget.dart';
import '../root_page/root_page.dart';

part 'init_router.g.dart';

/// The root navigator key — routes pushed with `parentNavigatorKey:
/// rootNavigatorKey` render ABOVE the 5-tab shell (`RootPage`), which is
/// what makes the bottom pill's absence on those screens STRUCTURAL rather
/// than a flag (design_spendlens.md §5 — "no `hideTabBar` boolean").
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Pure, testable redirect (design_spendlens.md §5): Splash → Onboarding →
/// Home, keyed ONLY on `onboardingCompleted`. No auth gate (the app is fully
/// usable anonymously, spec §8) and no connectivity gate
/// (`connectivity_plus` is blacklisted project-wide).
String? resolveRedirect({
  required bool onboardingCompleted,
  required String location,
}) {
  final isOnSplash = location == SplashPageRoute().location;
  final isOnOnboarding = location == OnboardingPageRoute().location;

  if (!onboardingCompleted) {
    return isOnOnboarding ? null : OnboardingPageRoute().location;
  }

  if (isOnSplash || isOnOnboarding) {
    return HomePageRoute().location;
  }

  return null;
}

GoRouter initRouter({required GoRouterRefreshListenable refreshListenable}) =>
    GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: SplashPageRoute().location,
      routes: $appRoutes,
      refreshListenable: refreshListenable,
      redirect: (context, state) => resolveRedirect(
        onboardingCompleted: refreshListenable.onboardingCompleted,
        location: state.matchedLocation,
      ),
    );

/// Bridges `SettingsBloc`'s stream to `GoRouter`'s `Listenable` contract, and
/// exposes the one field `redirect` actually needs — kept separate from
/// `SettingsBloc` itself so `resolveRedirect` stays a pure function callers
/// can test without constructing a bloc.
class GoRouterRefreshListenable extends ChangeNotifier {
  bool onboardingCompleted;
  late final StreamSubscription<bool> _subscription;

  GoRouterRefreshListenable(
    Stream<bool> onboardingCompletedStream, {
    required this.onboardingCompleted,
  }) {
    _subscription = onboardingCompletedStream.listen((value) {
      onboardingCompleted = value;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// The ONE shared page builder every top-level route below calls
/// (design_spendlens.md §5 — "one shared transition helper", never
/// per-route bespoke transitions).
///
/// Renamed from `slideUpPage`: it no longer slides, and a name describing a
/// transition the code does not perform is how the modal-looking push
/// survived review in the first place.
///
/// Uses the PLATFORM DEFAULT transition — a horizontal push on iOS, the
/// platform's own page animation on Android — because these are ordinary
/// pushed PAGES, not modals.
///
/// It previously slid the whole page up from the bottom edge
/// (`Offset(0, 1)` -> `zero`), which is the modal-sheet gesture and read as
/// wrong on a normal push. That was also a misreading of the design: its
/// `slUp` keyframe is `translateY(24px)` + `opacity 0 -> 1` — a subtle
/// 24-PIXEL fade-and-rise applied to a screen's CONTENT — not a
/// full-viewport-height page slide. (The old doc comment here said "Fade
/// transition" while the code slid, which is the tell.)
///
/// Real bottom sheets are unaffected: they use `showModalBottomSheet`,
/// which is a different mechanism entirely.
Page<void> appPage(Widget child) {
  return MaterialPage<void>(child: child);
}

// ─────────────────────────── top level ────────────────────────────────

/// `resolveRedirect` fires synchronously on GoRouter's very first navigation
/// evaluation to `/` — before this route's `buildPage` is ever invoked, in
/// EITHER branch (`!onboardingCompleted` → `/onboarding`; completed →
/// `/home`). This route therefore never actually paints; it exists only so
/// `initialLocation: '/'` and `resolveRedirect`'s location comparisons have
/// a registered route to resolve against. See `main.dart` for where
/// `FlutterNativeSplash.remove()` now lives, and why.
@TypedGoRoute<SplashPageRoute>(path: '/')
class SplashPageRoute extends GoRouteData with $SplashPageRoute {
  const SplashPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const LoadingDataWidget());
  }
}

@TypedGoRoute<OnboardingPageRoute>(path: '/onboarding')
class OnboardingPageRoute extends GoRouteData with $OnboardingPageRoute {
  const OnboardingPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const OnboardingPage());
  }
}

// ─────────────────────────── 5-branch shell ───────────────────────────
//
// Compare is withheld from production while it is unstable: its branch and
// route are removed rather than commented out (no_commented_code_rules.md).
// `lib/features/compare/` is kept intact, so restoring it means re-adding
// the branch here and the tab in `RootPage` at the same index.

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<HomePageRoute>(path: '/home'),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<AnalyticsPageRoute>(path: '/analytics'),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<StorePageRoute>(path: '/stores'),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<HistoryPageRoute>(path: '/history'),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<SettingsPageRoute>(path: '/settings'),
      ],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return RootPage(navigationShell: navigationShell);
  }
}

class HomePageRoute extends GoRouteData with $HomePageRoute {
  const HomePageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage<void>(child: const HomePage());
  }
}

class AnalyticsPageRoute extends GoRouteData with $AnalyticsPageRoute {
  const AnalyticsPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage<void>(child: const AnalyticsPage());
  }
}

class StorePageRoute extends GoRouteData with $StorePageRoute {
  const StorePageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage<void>(child: const StorePage());
  }
}

class HistoryPageRoute extends GoRouteData with $HistoryPageRoute {
  const HistoryPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage<void>(child: const HistoryPage());
  }
}

class SettingsPageRoute extends GoRouteData with $SettingsPageRoute {
  const SettingsPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage<void>(child: const SettingsPage());
  }
}

// ──────────────────── top-level pushes above the shell ────────────────
//
// Every route below carries `parentNavigatorKey: rootNavigatorKey`, which is
// what makes the bottom pill's absence STRUCTURAL (§5) — `RootPage` is never
// an ancestor of anything pushed on the root navigator.
//
// CHRONIC BUG GUARD (db:gorouter-parameterised-route-registered-before-
// literal-shadows-it): every family below that shares a path PREFIX has its
// LITERAL sibling registered strictly BEFORE its `:param` sibling in the
// `routes:` list — see the per-family comments for the exact ordering.

// ── Store family — literal `/store/new` BEFORE param `/store/:storeId` ──
@TypedGoRoute<NewStorePageRoute>(path: '/store/new')
class NewStorePageRoute extends GoRouteData with $NewStorePageRoute {
  const NewStorePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const NewStorePage());
  }
}

// The `/store/:storeId` family: `/store/:storeId/edit` is registered FIRST.
// go_router matches in registration order, so the bare `:storeId` route
// declared before it would capture `edit` as a store id and shadow the editor
// entirely (chronic bug
// `db:gorouter-parameterised-route-registered-before-literal-shadows-it`).
@TypedGoRoute<EditStorePageRoute>(path: '/store/:storeId/edit')
class EditStorePageRoute extends GoRouteData with $EditStorePageRoute {
  final String storeId;

  const EditStorePageRoute({required this.storeId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(EditStorePage(storeId: storeId));
  }
}

@TypedGoRoute<StoreDetailPageRoute>(path: '/store/:storeId')
class StoreDetailPageRoute extends GoRouteData with $StoreDetailPageRoute {
  final String storeId;

  const StoreDetailPageRoute({required this.storeId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(StoreDetailPage(storeId: storeId));
  }
}

@TypedGoRoute<ChooseStorePageRoute>(path: '/choose-store')
class ChooseStorePageRoute extends GoRouteData with $ChooseStorePageRoute {
  const ChooseStorePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const ChooseStorePage());
  }
}

// ── Category family — literal `/categories/new` BEFORE the list itself.
// There is no `/categories/:id` sibling in this app (no category detail
// route exists per design_spendlens.md §5's route list), so there is no
// shadow risk here — the ordering is kept literal-first anyway as the safe
// default for this exact path shape.
@TypedGoRoute<NewCategoryPageRoute>(path: '/categories/new')
class NewCategoryPageRoute extends GoRouteData with $NewCategoryPageRoute {
  const NewCategoryPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const NewCategoryPage());
  }
}

@TypedGoRoute<CategoriesPageRoute>(path: '/categories')
class CategoriesPageRoute extends GoRouteData with $CategoriesPageRoute {
  const CategoriesPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const CategoryPage());
  }
}

// ── Record/receipt detail family — `/record/:recordId` has no literal
// sibling (e.g. no `/record/new`), so no shadow risk; kept as its own
// top-level path.
@TypedGoRoute<RecordDetailPageRoute>(path: '/record/:recordId')
class RecordDetailPageRoute extends GoRouteData with $RecordDetailPageRoute {
  final String recordId;

  const RecordDetailPageRoute({required this.recordId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(RecordDetailPage(recordId: recordId));
  }
}

@TypedGoRoute<ReceiptPhotoPageRoute>(path: '/receipt/:receiptId/photo')
class ReceiptPhotoPageRoute extends GoRouteData with $ReceiptPhotoPageRoute {
  final String receiptId;

  const ReceiptPhotoPageRoute({required this.receiptId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(ReceiptPhotoPage(receiptId: receiptId));
  }
}

/// The `receiptId` value meaning "correct the UNSAVED scan currently held
/// on `PendingReceiptDraftStore`", used by Review's `Correct` button.
///
/// Review's Correct is pure navigation per the design — nothing is
/// persisted until Save Receipt — so at that point there is no receipt id
/// to route with. A sentinel keeps the route's `:receiptId` contract (and
/// its deep-linkability for a real saved receipt) instead of making the
/// parameter nullable for one caller.
const String kPendingDraftReceiptId = 'pending';

@TypedGoRoute<ReceiptStoragePageRoute>(path: '/receipt/:receiptId/storage')
class ReceiptStoragePageRoute extends GoRouteData
    with $ReceiptStoragePageRoute {
  final String receiptId;

  const ReceiptStoragePageRoute({required this.receiptId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(ReceiptStoragePage(receiptId: receiptId));
  }
}

@TypedGoRoute<EditReceiptPageRoute>(path: '/receipt/:receiptId/edit')
class EditReceiptPageRoute extends GoRouteData with $EditReceiptPageRoute {
  final String receiptId;

  const EditReceiptPageRoute({required this.receiptId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(EditReceiptPage(receiptId: receiptId));
  }
}

@TypedGoRoute<ScannerPageRoute>(path: '/scanner')
class ScannerPageRoute extends GoRouteData with $ScannerPageRoute {
  const ScannerPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const ScannerPage());
  }
}

@TypedGoRoute<ReviewPageRoute>(path: '/review')
class ReviewPageRoute extends GoRouteData with $ReviewPageRoute {
  const ReviewPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const ReviewPage());
  }
}

@TypedGoRoute<CashExpensePageRoute>(path: '/cash-expense')
class CashExpensePageRoute extends GoRouteData with $CashExpensePageRoute {
  const CashExpensePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const CashExpensePage());
  }
}

// ── Product family ──────────────────────────────────────────────────────
//
// There is no literal `/product/...` sibling today, but the family is laid
// out so one can be added SAFELY: any literal must be declared ABOVE the
// bare `:productId` route below, or go_router will capture the literal
// segment as a product id and shadow it entirely (chronic bug
// `db:gorouter-parameterised-route-registered-before-literal-shadows-it`) —
// exactly as the Store family above documents.
@TypedGoRoute<ChooseProductPageRoute>(path: '/choose-product')
class ChooseProductPageRoute extends GoRouteData with $ChooseProductPageRoute {
  /// Scope the candidates to one store (plus general-purpose products).
  final String? storeId;

  const ChooseProductPageRoute({this.storeId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(ChooseProductPage(storeId: storeId));
  }
}

// LITERAL `/product/new` is registered BEFORE the param `/product/:productId`
// below. go_router matches in registration order, so the bare `:productId`
// declared first would capture `new` as a product id and shadow this route
// entirely (chronic bug
// `db:gorouter-parameterised-route-registered-before-literal-shadows-it`).
@TypedGoRoute<NewProductPageRoute>(path: '/product/new')
class NewProductPageRoute extends GoRouteData with $NewProductPageRoute {
  /// The store the product is created for; null makes it general purpose.
  final String? storeId;

  const NewProductPageRoute({this.storeId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(NewProductPage(storeId: storeId));
  }
}

// `/product/:productId/edit` is registered BEFORE the bare `:productId`.
// go_router matches in registration order, so the bare param declared first
// would capture `edit` as a product id and shadow this route entirely
// (chronic bug
// `db:gorouter-parameterised-route-registered-before-literal-shadows-it`) —
// exactly as the Store family documents for `/store/:storeId/edit`.
@TypedGoRoute<EditProductPageRoute>(path: '/product/:productId/edit')
class EditProductPageRoute extends GoRouteData with $EditProductPageRoute {
  final String productId;

  const EditProductPageRoute({required this.productId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(EditProductPage(productId: productId));
  }
}

@TypedGoRoute<ProductDetailPageRoute>(path: '/product/:productId')
class ProductDetailPageRoute extends GoRouteData
    with $ProductDetailPageRoute {
  final String productId;

  const ProductDetailPageRoute({required this.productId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(ProductDetailPage(productId: productId));
  }
}

@TypedGoRoute<PriceHistoryPageRoute>(path: '/price-history/:productId')
class PriceHistoryPageRoute extends GoRouteData with $PriceHistoryPageRoute {
  final String productId;

  const PriceHistoryPageRoute({required this.productId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(PriceHistoryPage(productId: productId));
  }
}

@TypedGoRoute<ProfilePageRoute>(path: '/profile')
class ProfilePageRoute extends GoRouteData with $ProfilePageRoute {
  const ProfilePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const ProfilePage());
  }
}

/// Registered as a SIBLING of `/profile`, not a child of it.
///
/// `go_router_builder` nests routes by the `routes:` argument, not by path
/// prefix, so a literal `/profile/edit` here is an independent top-level entry
/// — which is what this screen wants: it pushes above the shell on the root
/// navigator and owns its own back control.
@TypedGoRoute<EditProfilePageRoute>(path: '/profile/edit')
class EditProfilePageRoute extends GoRouteData with $EditProfilePageRoute {
  const EditProfilePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const EditProfilePage());
  }
}

@TypedGoRoute<PrivacyPageRoute>(path: '/privacy')
class PrivacyPageRoute extends GoRouteData with $PrivacyPageRoute {
  const PrivacyPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const PrivacyPage());
  }
}

@TypedGoRoute<TermsPageRoute>(path: '/terms')
class TermsPageRoute extends GoRouteData with $TermsPageRoute {
  const TermsPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const TermsPage());
  }
}

@TypedGoRoute<AboutPageRoute>(path: '/about')
class AboutPageRoute extends GoRouteData with $AboutPageRoute {
  const AboutPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return appPage(const AboutPage());
  }
}

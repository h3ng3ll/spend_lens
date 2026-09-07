import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/analytics/presentation/pages/analytics_page/analytics_page.dart';
import '../../../features/analytics/presentation/pages/price_history_page/price_history_page.dart';
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
import '../../../features/receipt/presentation/pages/review_page/review_page.dart';
import '../../../features/scanner/presentation/pages/scanner_page/scanner_page.dart';
import '../../../features/settings/presentation/pages/about_page/about_page.dart';
import '../../../features/settings/presentation/pages/privacy_page/privacy_page.dart';
import '../../../features/settings/presentation/pages/settings_page/settings_page.dart';
import '../../../features/store/presentation/pages/choose_store_page/choose_store_page.dart';
import '../../../features/store/presentation/pages/new_store_page/new_store_page.dart';
import '../../../features/store/presentation/pages/store_detail_page/store_detail_page.dart';
import '../../../features/store/presentation/pages/store_page/store_page.dart';
import '../root_page/root_page.dart';
import '../splash_page/splash_page.dart';

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

/// Fade transition shared by every top-level push
/// (design_spendlens.md §5 — "one shared `slideUpPage()` transition helper").
/// Named to match the design's `slUp` timing family; the concrete curve/
/// duration match the design tokens once M5 builds real screens — M4 needs
/// only ONE shared helper every route below calls, not per-route bespoke
/// transitions.
CustomTransitionPage<void> slideUpPage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}

// ─────────────────────────── top level ────────────────────────────────

@TypedGoRoute<SplashPageRoute>(path: '/')
class SplashPageRoute extends GoRouteData with $SplashPageRoute {
  const SplashPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const SplashPage());
  }
}

@TypedGoRoute<OnboardingPageRoute>(path: '/onboarding')
class OnboardingPageRoute extends GoRouteData with $OnboardingPageRoute {
  const OnboardingPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const OnboardingPage());
  }
}

// ─────────────────────────── 5-branch shell ───────────────────────────

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
    return slideUpPage(const NewStorePage());
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
    return slideUpPage(StoreDetailPage(storeId: storeId));
  }
}

@TypedGoRoute<ChooseStorePageRoute>(path: '/choose-store')
class ChooseStorePageRoute extends GoRouteData with $ChooseStorePageRoute {
  const ChooseStorePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const ChooseStorePage());
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
    return slideUpPage(const NewCategoryPage());
  }
}

@TypedGoRoute<CategoriesPageRoute>(path: '/categories')
class CategoriesPageRoute extends GoRouteData with $CategoriesPageRoute {
  const CategoriesPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const CategoryPage());
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
    return slideUpPage(RecordDetailPage(recordId: recordId));
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
    return slideUpPage(ReceiptPhotoPage(receiptId: receiptId));
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
    return slideUpPage(EditReceiptPage(receiptId: receiptId));
  }
}

@TypedGoRoute<ScannerPageRoute>(path: '/scanner')
class ScannerPageRoute extends GoRouteData with $ScannerPageRoute {
  const ScannerPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const ScannerPage());
  }
}

@TypedGoRoute<ReviewPageRoute>(path: '/review')
class ReviewPageRoute extends GoRouteData with $ReviewPageRoute {
  const ReviewPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const ReviewPage());
  }
}

@TypedGoRoute<CashExpensePageRoute>(path: '/cash-expense')
class CashExpensePageRoute extends GoRouteData with $CashExpensePageRoute {
  const CashExpensePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const CashExpensePage());
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
    return slideUpPage(PriceHistoryPage(productId: productId));
  }
}

@TypedGoRoute<ProfilePageRoute>(path: '/profile')
class ProfilePageRoute extends GoRouteData with $ProfilePageRoute {
  const ProfilePageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const ProfilePage());
  }
}

@TypedGoRoute<PrivacyPageRoute>(path: '/privacy')
class PrivacyPageRoute extends GoRouteData with $PrivacyPageRoute {
  const PrivacyPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const PrivacyPage());
  }
}

@TypedGoRoute<AboutPageRoute>(path: '/about')
class AboutPageRoute extends GoRouteData with $AboutPageRoute {
  const AboutPageRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideUpPage(const AboutPage());
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $splashPageRoute,
  $onboardingPageRoute,
  $appShellRoute,
  $newStorePageRoute,
  $storeDetailPageRoute,
  $chooseStorePageRoute,
  $newCategoryPageRoute,
  $categoriesPageRoute,
  $recordDetailPageRoute,
  $receiptPhotoPageRoute,
  $receiptStoragePageRoute,
  $editReceiptPageRoute,
  $scannerPageRoute,
  $reviewPageRoute,
  $cashExpensePageRoute,
  $priceHistoryPageRoute,
  $profilePageRoute,
  $editProfilePageRoute,
  $privacyPageRoute,
  $termsPageRoute,
  $aboutPageRoute,
];

RouteBase get $splashPageRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $SplashPageRoute._fromState,
);

mixin $SplashPageRoute on GoRouteData {
  static SplashPageRoute _fromState(GoRouterState state) =>
      const SplashPageRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingPageRoute => GoRouteData.$route(
  path: '/onboarding',
  hasOverriddenOnExit: false,
  factory: $OnboardingPageRoute._fromState,
);

mixin $OnboardingPageRoute on GoRouteData {
  static OnboardingPageRoute _fromState(GoRouterState state) =>
      const OnboardingPageRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $appShellRoute => StatefulShellRouteData.$route(
  factory: $AppShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomePageRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/analytics',
          hasOverriddenOnExit: false,
          factory: $AnalyticsPageRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/stores',
          hasOverriddenOnExit: false,
          factory: $StorePageRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/history',
          hasOverriddenOnExit: false,
          factory: $HistoryPageRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          hasOverriddenOnExit: false,
          factory: $SettingsPageRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $HomePageRoute on GoRouteData {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AnalyticsPageRoute on GoRouteData {
  static AnalyticsPageRoute _fromState(GoRouterState state) =>
      const AnalyticsPageRoute();

  @override
  String get location => GoRouteData.$location('/analytics');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StorePageRoute on GoRouteData {
  static StorePageRoute _fromState(GoRouterState state) =>
      const StorePageRoute();

  @override
  String get location => GoRouteData.$location('/stores');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HistoryPageRoute on GoRouteData {
  static HistoryPageRoute _fromState(GoRouterState state) =>
      const HistoryPageRoute();

  @override
  String get location => GoRouteData.$location('/history');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsPageRoute on GoRouteData {
  static SettingsPageRoute _fromState(GoRouterState state) =>
      const SettingsPageRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newStorePageRoute => GoRouteData.$route(
  path: '/store/new',
  hasOverriddenOnExit: false,
  parentNavigatorKey: NewStorePageRoute.$parentNavigatorKey,
  factory: $NewStorePageRoute._fromState,
);

mixin $NewStorePageRoute on GoRouteData {
  static NewStorePageRoute _fromState(GoRouterState state) =>
      const NewStorePageRoute();

  @override
  String get location => GoRouteData.$location('/store/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $storeDetailPageRoute => GoRouteData.$route(
  path: '/store/:storeId',
  hasOverriddenOnExit: false,
  parentNavigatorKey: StoreDetailPageRoute.$parentNavigatorKey,
  factory: $StoreDetailPageRoute._fromState,
);

mixin $StoreDetailPageRoute on GoRouteData {
  static StoreDetailPageRoute _fromState(GoRouterState state) =>
      StoreDetailPageRoute(storeId: state.pathParameters['storeId']!);

  StoreDetailPageRoute get _self => this as StoreDetailPageRoute;

  @override
  String get location =>
      GoRouteData.$location('/store/${Uri.encodeComponent(_self.storeId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chooseStorePageRoute => GoRouteData.$route(
  path: '/choose-store',
  hasOverriddenOnExit: false,
  parentNavigatorKey: ChooseStorePageRoute.$parentNavigatorKey,
  factory: $ChooseStorePageRoute._fromState,
);

mixin $ChooseStorePageRoute on GoRouteData {
  static ChooseStorePageRoute _fromState(GoRouterState state) =>
      const ChooseStorePageRoute();

  @override
  String get location => GoRouteData.$location('/choose-store');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newCategoryPageRoute => GoRouteData.$route(
  path: '/categories/new',
  hasOverriddenOnExit: false,
  parentNavigatorKey: NewCategoryPageRoute.$parentNavigatorKey,
  factory: $NewCategoryPageRoute._fromState,
);

mixin $NewCategoryPageRoute on GoRouteData {
  static NewCategoryPageRoute _fromState(GoRouterState state) =>
      const NewCategoryPageRoute();

  @override
  String get location => GoRouteData.$location('/categories/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $categoriesPageRoute => GoRouteData.$route(
  path: '/categories',
  hasOverriddenOnExit: false,
  parentNavigatorKey: CategoriesPageRoute.$parentNavigatorKey,
  factory: $CategoriesPageRoute._fromState,
);

mixin $CategoriesPageRoute on GoRouteData {
  static CategoriesPageRoute _fromState(GoRouterState state) =>
      const CategoriesPageRoute();

  @override
  String get location => GoRouteData.$location('/categories');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $recordDetailPageRoute => GoRouteData.$route(
  path: '/record/:recordId',
  hasOverriddenOnExit: false,
  parentNavigatorKey: RecordDetailPageRoute.$parentNavigatorKey,
  factory: $RecordDetailPageRoute._fromState,
);

mixin $RecordDetailPageRoute on GoRouteData {
  static RecordDetailPageRoute _fromState(GoRouterState state) =>
      RecordDetailPageRoute(recordId: state.pathParameters['recordId']!);

  RecordDetailPageRoute get _self => this as RecordDetailPageRoute;

  @override
  String get location =>
      GoRouteData.$location('/record/${Uri.encodeComponent(_self.recordId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $receiptPhotoPageRoute => GoRouteData.$route(
  path: '/receipt/:receiptId/photo',
  hasOverriddenOnExit: false,
  parentNavigatorKey: ReceiptPhotoPageRoute.$parentNavigatorKey,
  factory: $ReceiptPhotoPageRoute._fromState,
);

mixin $ReceiptPhotoPageRoute on GoRouteData {
  static ReceiptPhotoPageRoute _fromState(GoRouterState state) =>
      ReceiptPhotoPageRoute(receiptId: state.pathParameters['receiptId']!);

  ReceiptPhotoPageRoute get _self => this as ReceiptPhotoPageRoute;

  @override
  String get location => GoRouteData.$location(
    '/receipt/${Uri.encodeComponent(_self.receiptId)}/photo',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $receiptStoragePageRoute => GoRouteData.$route(
  path: '/receipt/:receiptId/storage',
  hasOverriddenOnExit: false,
  parentNavigatorKey: ReceiptStoragePageRoute.$parentNavigatorKey,
  factory: $ReceiptStoragePageRoute._fromState,
);

mixin $ReceiptStoragePageRoute on GoRouteData {
  static ReceiptStoragePageRoute _fromState(GoRouterState state) =>
      ReceiptStoragePageRoute(receiptId: state.pathParameters['receiptId']!);

  ReceiptStoragePageRoute get _self => this as ReceiptStoragePageRoute;

  @override
  String get location => GoRouteData.$location(
    '/receipt/${Uri.encodeComponent(_self.receiptId)}/storage',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editReceiptPageRoute => GoRouteData.$route(
  path: '/receipt/:receiptId/edit',
  hasOverriddenOnExit: false,
  parentNavigatorKey: EditReceiptPageRoute.$parentNavigatorKey,
  factory: $EditReceiptPageRoute._fromState,
);

mixin $EditReceiptPageRoute on GoRouteData {
  static EditReceiptPageRoute _fromState(GoRouterState state) =>
      EditReceiptPageRoute(receiptId: state.pathParameters['receiptId']!);

  EditReceiptPageRoute get _self => this as EditReceiptPageRoute;

  @override
  String get location => GoRouteData.$location(
    '/receipt/${Uri.encodeComponent(_self.receiptId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $scannerPageRoute => GoRouteData.$route(
  path: '/scanner',
  hasOverriddenOnExit: false,
  parentNavigatorKey: ScannerPageRoute.$parentNavigatorKey,
  factory: $ScannerPageRoute._fromState,
);

mixin $ScannerPageRoute on GoRouteData {
  static ScannerPageRoute _fromState(GoRouterState state) =>
      const ScannerPageRoute();

  @override
  String get location => GoRouteData.$location('/scanner');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $reviewPageRoute => GoRouteData.$route(
  path: '/review',
  hasOverriddenOnExit: false,
  parentNavigatorKey: ReviewPageRoute.$parentNavigatorKey,
  factory: $ReviewPageRoute._fromState,
);

mixin $ReviewPageRoute on GoRouteData {
  static ReviewPageRoute _fromState(GoRouterState state) =>
      const ReviewPageRoute();

  @override
  String get location => GoRouteData.$location('/review');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cashExpensePageRoute => GoRouteData.$route(
  path: '/cash-expense',
  hasOverriddenOnExit: false,
  parentNavigatorKey: CashExpensePageRoute.$parentNavigatorKey,
  factory: $CashExpensePageRoute._fromState,
);

mixin $CashExpensePageRoute on GoRouteData {
  static CashExpensePageRoute _fromState(GoRouterState state) =>
      const CashExpensePageRoute();

  @override
  String get location => GoRouteData.$location('/cash-expense');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $priceHistoryPageRoute => GoRouteData.$route(
  path: '/price-history/:productId',
  hasOverriddenOnExit: false,
  parentNavigatorKey: PriceHistoryPageRoute.$parentNavigatorKey,
  factory: $PriceHistoryPageRoute._fromState,
);

mixin $PriceHistoryPageRoute on GoRouteData {
  static PriceHistoryPageRoute _fromState(GoRouterState state) =>
      PriceHistoryPageRoute(productId: state.pathParameters['productId']!);

  PriceHistoryPageRoute get _self => this as PriceHistoryPageRoute;

  @override
  String get location => GoRouteData.$location(
    '/price-history/${Uri.encodeComponent(_self.productId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profilePageRoute => GoRouteData.$route(
  path: '/profile',
  hasOverriddenOnExit: false,
  parentNavigatorKey: ProfilePageRoute.$parentNavigatorKey,
  factory: $ProfilePageRoute._fromState,
);

mixin $ProfilePageRoute on GoRouteData {
  static ProfilePageRoute _fromState(GoRouterState state) =>
      const ProfilePageRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editProfilePageRoute => GoRouteData.$route(
  path: '/profile/edit',
  hasOverriddenOnExit: false,
  parentNavigatorKey: EditProfilePageRoute.$parentNavigatorKey,
  factory: $EditProfilePageRoute._fromState,
);

mixin $EditProfilePageRoute on GoRouteData {
  static EditProfilePageRoute _fromState(GoRouterState state) =>
      const EditProfilePageRoute();

  @override
  String get location => GoRouteData.$location('/profile/edit');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $privacyPageRoute => GoRouteData.$route(
  path: '/privacy',
  hasOverriddenOnExit: false,
  parentNavigatorKey: PrivacyPageRoute.$parentNavigatorKey,
  factory: $PrivacyPageRoute._fromState,
);

mixin $PrivacyPageRoute on GoRouteData {
  static PrivacyPageRoute _fromState(GoRouterState state) =>
      const PrivacyPageRoute();

  @override
  String get location => GoRouteData.$location('/privacy');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $termsPageRoute => GoRouteData.$route(
  path: '/terms',
  hasOverriddenOnExit: false,
  parentNavigatorKey: TermsPageRoute.$parentNavigatorKey,
  factory: $TermsPageRoute._fromState,
);

mixin $TermsPageRoute on GoRouteData {
  static TermsPageRoute _fromState(GoRouterState state) =>
      const TermsPageRoute();

  @override
  String get location => GoRouteData.$location('/terms');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aboutPageRoute => GoRouteData.$route(
  path: '/about',
  hasOverriddenOnExit: false,
  parentNavigatorKey: AboutPageRoute.$parentNavigatorKey,
  factory: $AboutPageRoute._fromState,
);

mixin $AboutPageRoute on GoRouteData {
  static AboutPageRoute _fromState(GoRouterState state) =>
      const AboutPageRoute();

  @override
  String get location => GoRouteData.$location('/about');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

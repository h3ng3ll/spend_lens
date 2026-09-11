import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/app_theme.dart';
import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/widgets/app_container.dart';
import 'package:spend_lens/features/auth/presentation/pages/profile_page/widgets/plan_badge.dart';

/// Profile's Plan badge.
///
/// The row used to be `trailingText: lo.free` — a hardcoded string with a
/// fixed colour — so after a successful upgrade the badge kept reading
/// "Free" while the Storage card beside it already showed the premium
/// quota. One card contradicted the other on the same screen.
void main() {
  Future<void> pump(WidgetTester tester, {required bool isPremium}) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppThemeData.dark,
        home: Scaffold(
          body: PlanBadge(
            label: isPremium ? 'Premium' : 'Free',
            isPremium: isPremium,
          ),
        ),
      ),
    );
  }

  AppContainer badgeOf(WidgetTester tester) =>
      tester.widget<AppContainer>(find.byType(AppContainer).first);

  testWidgets('renders the label it is given', (tester) async {
    await pump(tester, isPremium: true);
    expect(find.text('Premium'), findsOneWidget);

    await pump(tester, isPremium: false);
    expect(find.text('Free'), findsOneWidget);
  });

  testWidgets('premium uses the accent gradient, free does not',
      (tester) async {
    await pump(tester, isPremium: true);
    expect(
      badgeOf(tester).gradient,
      isNotNull,
      reason: "The design's premium badge is the accent gradient pill.",
    );

    await pump(tester, isPremium: false);
    expect(badgeOf(tester).gradient, isNull);
  });

  testWidgets('free uses the bordered field pill', (tester) async {
    await pump(tester, isPremium: false);

    final badge = badgeOf(tester);
    expect(badge.color, isNotNull);
    expect(
      badge.border,
      isNotNull,
      reason: "The design's free badge carries a --line2 hairline.",
    );
  });

  testWidgets('the two states are visually distinct', (tester) async {
    await pump(tester, isPremium: true);
    final premium = badgeOf(tester);

    await pump(tester, isPremium: false);
    final free = badgeOf(tester);

    // The whole point of the fix: a user who upgrades must SEE the change.
    expect(
      premium.gradient != free.gradient || premium.color != free.color,
      isTrue,
    );
  });

  testWidgets('the label colour follows the tier', (tester) async {
    late Color premiumColor;
    late Color freeColor;

    await pump(tester, isPremium: true);
    premiumColor = tester.widget<Text>(find.text('Premium')).style!.color!;

    await pump(tester, isPremium: false);
    freeColor = tester.widget<Text>(find.text('Free')).style!.color!;

    expect(
      premiumColor,
      isNot(freeColor),
      reason: 'Gradient-backed text needs onAccent, not the muted --sec.',
    );

    final scheme = AppThemeData.dark.extension<AppColorScheme>()!;
    expect(premiumColor, scheme.onAccent);
    expect(freeColor, scheme.sec);
  });
}

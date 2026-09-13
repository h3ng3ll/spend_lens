import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/app_theme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/features/auth/presentation/pages/profile_page/widgets/delete_account_sheet.dart';
import 'package:spend_lens/features/auth/presentation/pages/profile_page/widgets/delete_account_subscription_notice.dart';

/// Deleting the account does NOT cancel the subscription — billing belongs to
/// the App Store / Play, and nothing in the deletion path can touch it.
///
/// Without the warning a user deletes their account, sees every trace of it
/// vanish, and keeps being charged for a Premium tier attached to an account
/// that no longer exists — with no way back into the app to find out why.
void main() {
  Widget host({required bool hasActiveSubscription}) => MaterialApp(
    theme: AppThemeData.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: DeleteAccountSheet(
        hasActiveSubscription: hasActiveSubscription,
        onManageSubscription: () {},
      ),
    ),
  );

  testWidgets('an active subscription is warned about before the choice', (
    tester,
  ) async {
    await tester.pumpWidget(host(hasActiveSubscription: true));
    await tester.pumpAndSettle();

    expect(find.byType(DeleteAccountSubscriptionNotice), findsOneWidget);
  });

  testWidgets('a free user sees no billing warning', (tester) async {
    // Not noise-suppression for its own sake: an unconditional warning would
    // be a false statement for a user who has no subscription, at the exact
    // moment they need to read carefully.
    await tester.pumpWidget(host(hasActiveSubscription: false));
    await tester.pumpAndSettle();

    expect(find.byType(DeleteAccountSubscriptionNotice), findsNothing);
  });

  testWidgets('the warning offers a way to act on it', (tester) async {
    var managed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeData.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: DeleteAccountSubscriptionNotice(
            onManage: () => managed = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final lo = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.text(lo.deleteAccountSubscriptionAction));
    await tester.pump();

    expect(managed, isTrue);
  });

  testWidgets('both deletion scopes are still offered', (tester) async {
    await tester.pumpWidget(host(hasActiveSubscription: true));
    await tester.pumpAndSettle();

    final lo = await AppLocalizations.delegate.load(const Locale('en'));

    // The warning must not crowd out the choices it is context for.
    expect(find.text(lo.deleteAccountEverywhere), findsOneWidget);
    expect(find.text(lo.deleteAccountCloudOnly), findsOneWidget);
  });
}

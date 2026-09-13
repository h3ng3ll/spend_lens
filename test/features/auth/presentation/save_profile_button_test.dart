import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/app_theme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/core/widgets/gradient_cta_button.dart';
import 'package:spend_lens/features/auth/presentation/pages/edit_profile_page/widgets/save_profile_button.dart';

/// Every slow phase on the edit screen must show an indicator.
///
/// The reported defect: tapping a photo option, and tapping Save, both left the
/// screen looking unchanged while real work ran — the OS picker plus
/// `readAsBytes`, then compression and upload. A greyed-out button is
/// indistinguishable from a dead one, which is what makes a user tap again or
/// back out mid-upload.
void main() {
  Widget host({
    bool isSaving = false,
    bool isPickingPhoto = false,
    bool isUploadingPhoto = false,
    bool canSave = true,
  }) => MaterialApp(
    theme: AppThemeData.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SaveProfileButton(
        isSaving: isSaving,
        isPickingPhoto: isPickingPhoto,
        isUploadingPhoto: isUploadingPhoto,
        canSave: canSave,
        onSave: () {},
      ),
    ),
  );

  Future<AppLocalizations> lo() =>
      AppLocalizations.delegate.load(const Locale('en'));

  testWidgets('idle shows the normal Save button', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    expect(find.byType(GradientCtaButton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('picking a photo shows an indicator', (tester) async {
    await tester.pumpWidget(host(isPickingPhoto: true));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text((await lo()).processingPhoto), findsOneWidget);
    expect(
      find.byType(GradientCtaButton),
      findsNothing,
      reason: 'the live button must be gone, not merely disabled',
    );
  });

  testWidgets('uploading names the upload phase', (tester) async {
    await tester.pumpWidget(host(isSaving: true, isUploadingPhoto: true));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text((await lo()).uploadingPhoto), findsOneWidget);
  });

  testWidgets('a name-only save says saving, not uploading', (tester) async {
    await tester.pumpWidget(host(isSaving: true));
    await tester.pump();

    final strings = await lo();
    expect(find.text(strings.savingProfile), findsOneWidget);
    expect(find.text(strings.uploadingPhoto), findsNothing);
  });

  testWidgets('a busy button cannot be tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeData.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SaveProfileButton(
            isSaving: true,
            isPickingPhoto: false,
            isUploadingPhoto: true,
            canSave: true,
            onSave: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(SaveProfileButton));
    await tester.pump();

    expect(tapped, isFalse, reason: 'a save is already irreversibly in flight');
  });
}

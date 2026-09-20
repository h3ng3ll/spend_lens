import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/localization/gen/app_localizations.dart';
import 'package:spend_lens/core/resources/text/app_text_theme.dart';
import 'package:spend_lens/features/auth/presentation/pages/profile_page/widgets/storage_card.dart';
import 'package:spend_lens/features/sync/presentation/bloc/sync_bloc/sync_bloc.dart';

/// REGRESSION: the Profile screen's Storage card overflowed on the right.
///
///     A RenderFlex overflowed by 31 pixels on the right.
///     Row ... storage_card.dart:67
///
/// The header row is `spaceBetween` with the label on one side and the usage
/// figure on the other, and NEITHER was bounded. English fits, so it shipped;
/// Russian does not — `Облачное хранилище` against `5 MB из 100 MB` runs past
/// the edge and Flutter paints the yellow-and-black overflow stripes over the
/// card.
///
/// `flutter analyze` cannot see this: it is a layout-constraint outcome that
/// depends on the resolved string. Pumping the real widget in the locale that
/// breaks it is what catches it.
void main() {
  Widget harness({required Locale locale, required int usedBytes}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        extensions: [AppColorScheme.dark(), AppTextTheme.base()],
      ),
      home: BlocProvider<SyncBloc>(
        create: (_) => _FakeSyncBloc(usedBytes: usedBytes),
        child: Scaffold(
          body: StorageCard(
            deviceNoun: 'this device',
            isSignedIn: true,
            isPurchaseAvailable: true,
            onUpgrade: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('does not overflow in Russian — the reported case', (
    tester,
  ) async {
    // The narrowest phone the app targets; a wider surface hides the bug.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      harness(locale: const Locale('ru'), usedBytes: 5 * 1024 * 1024),
    );
    await tester.pumpAndSettle();

    expect(
      tester.takeException(),
      isNull,
      reason: 'A RenderFlex overflow is thrown as an exception in tests.',
    );
  });

  testWidgets('does not overflow in any supported locale', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // German and Romanian are the other long-label candidates; running the
    // whole supported set means a locale added later is covered by existing
    // rather than by someone remembering to add a line here.
    for (final locale in AppLocalizations.supportedLocales) {
      await tester.pumpWidget(
        harness(locale: locale, usedBytes: 5 * 1024 * 1024),
      );
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: 'Storage card overflowed in ${locale.languageCode}.',
      );
    }
  });

  testWidgets('still renders the usage figure unabbreviated', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      harness(locale: const Locale('en'), usedBytes: 5 * 1024 * 1024),
    );
    await tester.pumpAndSettle();

    // The fix flexes the LABEL, not the amount: the number is what the row
    // exists to show, so it must never be the thing that gets ellipsized.
    expect(find.textContaining('100 MB'), findsWidgets);
  });
}

class _FakeSyncBloc extends Cubit<SyncState> implements SyncBloc {
  _FakeSyncBloc({required int usedBytes})
    : super(SyncState(usedBytes: usedBytes));

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

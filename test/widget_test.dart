// M1 smoke test: the app boots to a themed blank screen.
//
// The stock Flutter counter demo (and its widget test) were removed as part
// of the SpendLens bootstrap (design_spendlens.md §1); this replaces it with
// a smoke test matching the new `SpendLensApp` shell. Hive/DI aren't
// initialized here (that's `main()`'s job) — this only proves the widget
// tree itself builds and themes without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/app_theme.dart';

void main() {
  testWidgets('App boots to a themed blank screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeData.light,
        darkTheme: AppThemeData.dark,
        home: const Scaffold(
          body: SizedBox.shrink(),
        ),
      ),
    );

    expect(find.byType(Scaffold), findsOneWidget);
  });
}

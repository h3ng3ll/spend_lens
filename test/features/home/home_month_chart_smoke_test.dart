import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/resources/colors/app_color_scheme.dart';
import 'package:spend_lens/core/resources/text/app_text_theme.dart';
import 'package:spend_lens/features/home/presentation/pages/home_page/widgets/home_month_chart_section.dart';
import 'package:spend_lens/features/home/presentation/utils/home_calculations.dart';

/// The chart sits inside Home's `SingleChildScrollView`, so its cross axis is
/// unbounded — the same shape that once turned the Store Detail screen black
/// ("BoxConstraints forces an infinite height"). `flutter analyze` cannot see
/// a layout-constraint contract; only pumping the real widget can.
Future<void> pumpChart(WidgetTester tester, List<DailySpend> days) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        extensions: [AppColorScheme.dark(), AppTextTheme.base()],
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: HomeMonthChartSection(days: days, label: 'this month'),
        ),
      ),
    ),
  );
}

List<DailySpend> month({required bool withData}) => [
  for (var day = 1; day <= 30; day++)
    DailySpend(
      day: day,
      amount: withData && day == 19 ? 1744.74 : 0.0,
      hasData: withData && day == 19,
    ),
];

void main() {
  testWidgets('renders inside an unbounded scroll view', (tester) async {
    await pumpChart(tester, month(withData: true));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('THIS MONTH'), findsOneWidget);
  });

  testWidgets('renders a month with NO spend at all', (tester) async {
    // Every bar is a stub and the axis ceiling would be 0 — `fl_chart` lays
    // out a degenerate axis for `maxY: 0`, so the widget floors it.
    await pumpChart(tester, month(withData: false));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('survives a large system text scale', (tester) async {
    // The day labels reserve scaled space, not a fixed dp height (chronic
    // `developer-derived-fixed-dp-cell-height-ignores-textScaleFactor`).
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await pumpChart(tester, month(withData: true));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

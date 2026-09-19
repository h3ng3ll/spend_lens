import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/features/analytics/domain/insights/analytics_insight_generator.dart';
import 'package:spend_lens/features/analytics/domain/models/analytics_insight/analytics_insight.dart';
import 'package:spend_lens/features/analytics/domain/models/monthly_summary/category_share.dart';
import 'package:spend_lens/features/analytics/domain/models/monthly_summary/monthly_summary.dart';

MonthlySummary _summary({
  required List<CategoryShare> shares,
  double? previousMonthTotal,
  double? previousMonthAveragePurchase,
  double total = 100.0,
  int month = 8,
}) {
  return MonthlySummary(
    year: 2026,
    month: month,
    currencyCode: 'MDL',
    total: total,
    purchaseCount: 5,
    averagePurchase: 20.0,
    cashShare: 0.5,
    categoryShares: shares,
    previousMonthTotal: previousMonthTotal,
    previousMonthAveragePurchase: previousMonthAveragePurchase,
  );
}

void main() {
  group('generateInsights', () {
    test('emits (ARB key, params) pairs, never rendered strings', () {
      final summary = _summary(
        shares: const [
          CategoryShare(
            categoryId: 'catFood',
            amount: 57.0,
            count: 3,
            sharePercent: 57.0,
          ),
        ],
        previousMonthTotal: 76.19, // total 100 / previous 76.19 => +31.25%
      );

      final insights = generateInsights(
        summary: summary,
        isCurrentMonth: true,
        topCategoryId: 'catFood',
        currentMonthAverageDisplay: '20',
        previousMonthAverageDisplay: '15',
      );

      expect(insights, isNotEmpty);
      for (final insight in insights) {
        // The generator's output type carries an enum key + a params list —
        // there is structurally no String field it could have rendered
        // into. This is the test that would fail if a future edit made the
        // generator return rendered text instead.
        expect(insight, isA<AnalyticsInsight>());
        expect(insight.key, isA<EAnalyticsInsightKey>());
        expect(insight.params, isA<List<Object>>());
      }
    });

    test(
      'a NON-Food top category still produces an insight in the CURRENT month',
      () {
        // Regression: this branch used to be gated on `!isCurrentMonth`, so a
        // user whose top category was not Food got NO top-category insight at
        // all for the current month. Combined with the other two insights
        // needing prior-month data, the whole Insights card collapsed to
        // `SizedBox.shrink()` — the screen's "doesn't informate" symptom.
        final summary = _summary(
          shares: const [
            CategoryShare(
              categoryId: 'catTransport',
              amount: 62.0,
              count: 3,
              sharePercent: 62.0,
            ),
          ],
        );

        final insights = generateInsights(
          summary: summary,
          isCurrentMonth: true,
          topCategoryId: 'catTransport',
        );

        final insA1 = insights.firstWhere(
          (insight) => insight.key == EAnalyticsInsightKey.insA1,
        );
        expect(insA1.params, ['catTransport', 62]);
      },
    );

    test('ins3 fires once a previous-month average exists', () {
      // Regression: `previousMonthAverageDisplay` was hardcoded to null at the
      // call site and `MonthlySummary` had no field to supply it, so this
      // insight was structurally impossible to emit.
      final summary = _summary(
        shares: const [
          CategoryShare(
            categoryId: 'catFood',
            amount: 57.0,
            count: 4,
            sharePercent: 57.0,
          ),
        ],
        previousMonthTotal: 80.0,
        previousMonthAveragePurchase: 16.0,
      );

      final insights = generateInsights(
        summary: summary,
        isCurrentMonth: true,
        topCategoryId: 'catFood',
        previousMonthAverageDisplay: summary.previousMonthAveragePurchase
            ?.round()
            .toString(),
        currentMonthAverageDisplay: summary.averagePurchase.round().toString(),
      );

      final ins3 = insights.firstWhere(
        (insight) => insight.key == EAnalyticsInsightKey.ins3,
      );
      expect(ins3.params, ['16', '20', 'MDL']);
    });

    test('ins1 is emitted (deterministically) when Food is the top category, current month', () {
      final summary = _summary(
        shares: const [
          CategoryShare(
            categoryId: 'catFood',
            amount: 57.0,
            count: 3,
            sharePercent: 57.0,
          ),
        ],
      );

      final insights = generateInsights(
        summary: summary,
        isCurrentMonth: true,
        topCategoryId: 'catFood',
      );

      final ins1 = insights.firstWhere(
        (insight) => insight.key == EAnalyticsInsightKey.ins1,
      );
      expect(ins1.params, [57]);
    });

    test('ins2 direction param is trendIncreased when spending rose', () {
      final summary = _summary(
        shares: const [
          CategoryShare(
            categoryId: 'catRestaurantsCoffee',
            amount: 100.0,
            count: 2,
            sharePercent: 100.0,
          ),
        ],
        previousMonthTotal: 75.76, // => +32.0%
        total: 100.0,
      );

      final insights = generateInsights(
        summary: summary,
        isCurrentMonth: true,
        topCategoryId: 'catRestaurantsCoffee',
      );

      final ins2 = insights.firstWhere(
        (insight) => insight.key == EAnalyticsInsightKey.ins2,
      );
      expect(ins2.params[0], 'catRestaurantsCoffee');
      expect(ins2.params[1], 'trendIncreased');
    });

    test('ins2 direction param is trendDecreased when spending fell', () {
      final summary = _summary(
        shares: const [
          CategoryShare(
            categoryId: 'catFood',
            amount: 50.0,
            count: 2,
            sharePercent: 100.0,
          ),
        ],
        previousMonthTotal: 100.0,
        total: 50.0,
      );

      final insights = generateInsights(
        summary: summary,
        isCurrentMonth: true,
        topCategoryId: 'catFood',
      );

      final ins2 = insights.firstWhere(
        (insight) => insight.key == EAnalyticsInsightKey.ins2,
      );
      expect(ins2.params[1], 'trendDecreased');
    });

    test('ins3 emitted only when the average genuinely changed', () {
      // A non-empty categoryShares is required — the generator returns
      // early (no insights at all) when there is nothing to report on.
      final summary = _summary(
        shares: const [
          CategoryShare(
            categoryId: 'catTransport',
            amount: 10.0,
            count: 1,
            sharePercent: 100.0,
          ),
        ],
      );

      final changed = generateInsights(
        summary: summary,
        isCurrentMonth: true,
        topCategoryId: 'catTransport',
        previousMonthAverageDisplay: '143',
        currentMonthAverageDisplay: '167',
      );
      expect(
        changed.any((i) => i.key == EAnalyticsInsightKey.ins3),
        isTrue,
      );

      final unchanged = generateInsights(
        summary: summary,
        isCurrentMonth: true,
        topCategoryId: 'catTransport',
        previousMonthAverageDisplay: '143',
        currentMonthAverageDisplay: '143',
      );
      expect(
        unchanged.any((i) => i.key == EAnalyticsInsightKey.ins3),
        isFalse,
      );
    });

    test('insA2 (archived month) is only emitted when spending FELL', () {
      final fellSummary = _summary(
        shares: const [
          CategoryShare(
            categoryId: 'catFood',
            amount: 50.0,
            count: 1,
            sharePercent: 100.0,
          ),
        ],
        previousMonthTotal: 100.0,
        total: 50.0,
        month: 7, // archived month
      );

      final fellInsights = generateInsights(
        summary: fellSummary,
        isCurrentMonth: false,
        topCategoryId: 'catFood',
        currentMonthAverageDisplay: '20',
      );
      expect(
        fellInsights.any((i) => i.key == EAnalyticsInsightKey.insA2),
        isTrue,
      );

      final roseSummary = _summary(
        shares: const [
          CategoryShare(
            categoryId: 'catFood',
            amount: 150.0,
            count: 1,
            sharePercent: 100.0,
          ),
        ],
        previousMonthTotal: 100.0,
        total: 150.0,
        month: 7,
      );

      final roseInsights = generateInsights(
        summary: roseSummary,
        isCurrentMonth: false,
        topCategoryId: 'catFood',
        currentMonthAverageDisplay: '20',
      );
      expect(
        roseInsights.any((i) => i.key == EAnalyticsInsightKey.insA2),
        isFalse,
      );
    });

    test('no insights when there is no category data to report', () {
      final summary = _summary(shares: const []);

      final insights = generateInsights(
        summary: summary,
        isCurrentMonth: true,
        topCategoryId: '',
      );

      expect(insights, isEmpty);
    });
  });
}

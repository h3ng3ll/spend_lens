import '../models/analytics_insight/analytics_insight.dart';
import '../models/monthly_summary/monthly_summary.dart';

/// The analytics engine's insight generator (design_spendlens.md §6/§10,
/// spec §53) — a pure function over two [MonthlySummary]s. Emits
/// **(ARB key, params) pairs only**, never rendered strings, so the result
/// is locale-independent and unit-testable without a `BuildContext`.
///
/// Uses exactly the six keys design_spendlens.md §4.4 names as
/// already-parameterized: `ins1`/`ins2`/`ins3` describe the CURRENT month,
/// `insA1`/`insA2`/`insA3` describe a PAST (archived) month. [isCurrentMonth]
/// selects which trio applies; callers never invent a seventh key.
///
/// `ins1`/`insA1` is deliberately Food-specific — the ARB template text
/// itself reads "Food represents {p}%..." in every one of the 7 languages
/// (verified: this is the design's own worked example, not a per-category
/// slot), so this generator only emits it when Food genuinely is the top
/// category. A different top category never gets shoehorned into that
/// string.
List<AnalyticsInsight> generateInsights({
  required MonthlySummary summary,
  required bool isCurrentMonth,
  required String topCategoryId,
  String? previousMonthAverageDisplay,
  String? currentMonthAverageDisplay,
}) {
  final insights = <AnalyticsInsight>[];

  if (summary.categoryShares.isEmpty) {
    return insights;
  }

  final topShare = summary.categoryShares.first;
  final isFoodTop = topShare.categoryId == topCategoryId &&
      _isFoodCategory(topShare.categoryId);

  if (isFoodTop && topShare.sharePercent > 0) {
    insights.add(
      AnalyticsInsight(
        key: isCurrentMonth
            ? EAnalyticsInsightKey.ins1
            : EAnalyticsInsightKey.insA1,
        params: isCurrentMonth
            ? [topShare.sharePercent.round()]
            : [topCategoryId, topShare.sharePercent.round()],
      ),
    );
  } else if (!isCurrentMonth && topShare.sharePercent > 0) {
    // insA1 template is "{category} represented {percent}%..." — genuinely
    // category-parameterized (unlike ins1), so a non-Food top category can
    // still use it for a past month.
    insights.add(
      AnalyticsInsight(
        key: EAnalyticsInsightKey.insA1,
        params: [topCategoryId, topShare.sharePercent.round()],
      ),
    );
  }

  final percentChange = summary.percentChangeVsPreviousMonth;
  if (isCurrentMonth && percentChange != null && percentChange != 0) {
    insights.add(
      AnalyticsInsight(
        key: EAnalyticsInsightKey.ins2,
        params: [
          topCategoryId,
          percentChange > 0 ? 'trendIncreased' : 'trendDecreased',
          percentChange.abs().round(),
        ],
      ),
    );
  } else if (!isCurrentMonth && percentChange != null && percentChange < 0) {
    // insA2 template is "{category} spending fell {percent}% in {month}." —
    // only ever the FELL direction; a rise in an archived month has no
    // matching key and is intentionally not reported here.
    insights.add(
      AnalyticsInsight(
        key: EAnalyticsInsightKey.insA2,
        params: [topCategoryId, percentChange.abs().round(), summary.month],
      ),
    );
  }

  if (isCurrentMonth &&
      previousMonthAverageDisplay != null &&
      currentMonthAverageDisplay != null &&
      previousMonthAverageDisplay != currentMonthAverageDisplay) {
    insights.add(
      AnalyticsInsight(
        key: EAnalyticsInsightKey.ins3,
        params: [
          previousMonthAverageDisplay,
          currentMonthAverageDisplay,
          summary.currencyCode,
        ],
      ),
    );
  } else if (!isCurrentMonth && currentMonthAverageDisplay != null) {
    insights.add(
      AnalyticsInsight(
        key: EAnalyticsInsightKey.insA3,
        params: [currentMonthAverageDisplay, summary.currencyCode],
      ),
    );
  }

  return insights;
}

bool _isFoodCategory(String categoryId) =>
    categoryId == 'catFood' || categoryId == 'Food';

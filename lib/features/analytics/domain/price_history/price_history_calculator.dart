/// The price-history calculator (spec §54–57, design_spendlens.md §10/§11)
/// — pure functions only, so tests need no mocks. Reproduces the design's
/// worked example exactly: `18.50 → 22.90 = +23.8%`
/// (`percentChange(18.50, 22.90)` below).
///
/// Currency is a DISPLAY LABEL: [displayCurrencyCode] labels the series'
/// axis and readouts but never selects which observations are charted, and
/// prices are never converted or re-denominated.
///
/// This replaces an earlier filter on `observation.currencyCode ==
/// displayCurrencyCode`. Observations are written with a fixed code while
/// the setting is user-changeable, so that filter blanked the chart
/// entirely the moment the two differed — the same defect that zeroed the
/// Analytics screen. Deviation from spec §52 recorded per the user's
/// decision that the currency setting is display-only.
library;

import '../models/price_history/price_history_point.dart';
import '../models/price_history/price_history_summary.dart';
import '../models/price_observation/price_observation.dart';

/// Percent change from [from] to [to], e.g. `percentChange(18.50, 22.90)`
/// is `+23.8` (rounds to one decimal place, matching the design's stated
/// worked example). Returns null when [from] is 0 (no baseline to compare
/// against — never a divide-by-zero).
double? percentChange(double from, double to) {
  if (from == 0) return null;
  final raw = ((to - from) / from) * 100;
  return (raw * 10).round() / 10;
}

/// Builds one bar per calendar month between the EARLIEST and LATEST
/// observation (inclusive), for [productId] in [displayCurrencyCode] only.
/// A month with no matching observation becomes
/// `PriceHistoryPoint.empty(...)` — [PriceHistoryPoint.hasData] is false —
/// rather than being omitted, so the chart's x-axis stays continuous.
///
/// When a period has MULTIPLE observations, the LATEST one (by
/// `observedAt`) wins — the chart shows one bar per period, not an average
/// that would blur a real price change.
PriceHistorySummary buildPriceHistory({
  required String productId,
  required List<PriceObservation> allObservations,
  required String displayCurrencyCode,
}) {
  final matching =
      allObservations
          .where(
            (observation) =>
                observation.productId == productId &&
                observation.deletedAt == null,
          )
          .toList()
        ..sort((a, b) => a.observedAt.compareTo(b.observedAt));

  if (matching.isEmpty) {
    return PriceHistorySummary(
      productId: productId,
      currencyCode: displayCurrencyCode,
      points: const [],
      percentChangeFirstToLast: null,
    );
  }

  final byMonth = <DateTime, PriceObservation>{};
  for (final observation in matching) {
    final monthKey = DateTime(
      observation.observedAt.year,
      observation.observedAt.month,
    );
    final existing = byMonth[monthKey];
    if (existing == null ||
        observation.observedAt.isAfter(existing.observedAt)) {
      byMonth[monthKey] = observation;
    }
  }

  final firstMonth = DateTime(
    matching.first.observedAt.year,
    matching.first.observedAt.month,
  );
  final lastMonth = DateTime(
    matching.last.observedAt.year,
    matching.last.observedAt.month,
  );

  final points = <PriceHistoryPoint>[];
  var cursor = firstMonth;
  while (!cursor.isAfter(lastMonth)) {
    final observation = byMonth[cursor];
    points.add(
      observation == null
          ? PriceHistoryPoint.empty(cursor)
          : PriceHistoryPoint(
              periodStart: cursor,
              unitPrice: observation.comparableUnitPrice,
              storeId: observation.storeId,
              hasData: true,
            ),
    );
    cursor = DateTime(cursor.year, cursor.month + 1);
  }

  final withData = points.where((point) => point.hasData).toList();
  final overallChange = withData.length < 2
      ? null
      : percentChange(withData.first.unitPrice, withData.last.unitPrice);

  return PriceHistorySummary(
    productId: productId,
    currencyCode: displayCurrencyCode,
    points: points,
    percentChangeFirstToLast: overallChange,
  );
}

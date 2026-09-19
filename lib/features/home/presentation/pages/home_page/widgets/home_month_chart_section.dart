import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';
import '../../../utils/home_calculations.dart';

/// Home's daily spend chart for the current month, sitting directly under
/// the hero's "vs last month" line.
///
/// Presentational only (A3.6 Container/Section split): it takes the already
/// computed [days] and a pre-resolved [label], reads nothing from a bloc,
/// and resolves colour only from the scheme — never a raw literal.
class HomeMonthChartSection extends StatelessWidget {
  /// Every calendar day of the month, in order — including empty ones, so
  /// the x-axis is the month rather than only the days that have data.
  final List<DailySpend> days;

  /// Uppercased by [SectionLabel]; passed in so this widget stays
  /// localization-agnostic.
  final String label;

  const HomeMonthChartSection({
    super.key,
    required this.days,
    required this.label,
  });

  /// The tallest bar's value, used as the y-axis ceiling.
  ///
  /// Never returns 0: `fl_chart` given `maxY: 0` lays out a degenerate axis,
  /// and the empty-day stubs below still need a scale to sit on.
  double get _maxAmount {
    var max = 0.0;
    for (final day in days) {
      if (day.amount > max) max = day.amount;
    }
    return max <= 0.0 ? 1.0 : max;
  }

  /// Only the first, middle and last day get a label — 30 numbers across a
  /// phone width is unreadable, and at that size they collide.
  bool _isLabelledDay(int day) =>
      day == 1 || day == days.length || day == (days.length / 2).round();

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    final maxAmount = _maxAmount;

    return AppSectionCard(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.0,
        children: [
          SectionLabel(text: label),
          SizedBox(
            height: 160.0,
            child: BarChart(
              BarChartData(
                maxY: maxAmount,
                minY: 0.0,
                alignment: BarChartAlignment.spaceBetween,
                barGroups: _barGroups(scheme, maxAmount),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      // Scaled, not a bare dp constant: this reserves space
                      // for TEXT, and a fixed height clips the label at a
                      // large system font size (recorded chronic
                      // `developer-derived-fixed-dp-cell-height-ignores-
                      // textScaleFactor`).
                      reservedSize: MediaQuery.textScalerOf(
                        context,
                      ).scale(22.0),
                      getTitlesWidget: (value, meta) =>
                          _dayLabel(value, textTheme, scheme),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayLabel(
    double value,
    AppTextTheme textTheme,
    AppColorScheme scheme,
  ) {
    final day = value.round() + 1;
    if (!_isLabelledDay(day)) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text(
        '$day',
        style: textTheme.footnote13.copyWith(color: scheme.ter),
      ),
    );
  }

  /// One rod per day.
  ///
  /// A day with NO spend is drawn as a faint, near-flat stub in `line2`
  /// rather than as a zero-height accent bar. Painting it with the data fill
  /// is the recorded chronic
  /// `chart-zero-value-bar-paints-the-data-fill-so-empty-reads-as-measured`:
  /// the reader cannot tell "nothing was spent" from "a tiny amount was".
  List<BarChartGroupData> _barGroups(AppColorScheme scheme, double maxAmount) {
    // The stub is a fraction of the axis, so it stays visually flat whatever
    // the month's peak happens to be.
    final stubHeight = maxAmount * 0.015;

    return [
      for (var i = 0; i < days.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            if (days[i].hasData)
              BarChartRodData(
                toY: days[i].amount,
                width: 6.0,
                borderRadius: BorderRadius.circular(3.0),
                gradient: scheme.accentGradient,
              )
            else
              BarChartRodData(
                toY: stubHeight,
                width: 6.0,
                borderRadius: BorderRadius.circular(3.0),
                color: scheme.line2,
              ),
          ],
        ),
    ];
  }
}

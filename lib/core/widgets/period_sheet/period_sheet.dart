import 'package:flutter/material.dart';

import '../../resources/colors/app_color_scheme.dart';
import '../../resources/localization/gen/app_localizations.dart';
import '../../resources/text/app_text_theme.dart';
import '../../utils/selected_period.dart';
import '../app_container.dart';
import '../padding/horizontal_padding.dart';
import 'widgets/period_month_cell.dart';
import 'widgets/period_year_stepper.dart';

/// The Period picker — a bottom sheet, NOT a route (design_spendlens.md §5).
/// Shared by Home and Analytics, both of which read a [SelectedPeriod] to
/// decide which month's records to show.
///
/// **Deliberately-not-built** (design_spendlens.md, "Deliberately not
/// built"): the year stepper stays styled-disabled — only the current
/// year's months with recorded data are selectable, per the v1 "disabled
/// button" state (verified at `SpendLens Prototype.dc.html` line 946/947:
/// both arrows are `color:var(--dim)` + `cursor:default` + a no-op
/// `onClick`). This is NOT a bug to "complete" — see
/// `PeriodYearStepper`'s own doc comment for the chronic-bug guard this
/// upholds.
class PeriodSheet extends StatelessWidget {
  final SelectedPeriod selected;
  final int minSelectableMonth;
  final int maxSelectableMonth;
  final ValueChanged<SelectedPeriod> onSelect;

  const PeriodSheet({
    super.key,
    required this.selected,
    required this.minSelectableMonth,
    required this.maxSelectableMonth,
    required this.onSelect,
  });

  static Future<void> show(
    BuildContext context, {
    required SelectedPeriod selected,
    required int minSelectableMonth,
    required int maxSelectableMonth,
    required ValueChanged<SelectedPeriod> onSelect,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      // Root navigator, above the 5-tab shell — see `CurrencySheet.show`.
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (sheetContext) => PeriodSheet(
        selected: selected,
        minSelectableMonth: minSelectableMonth,
        maxSelectableMonth: maxSelectableMonth,
        onSelect: onSelect,
      ),
    );
  }

  void _onPick(BuildContext context, int month) {
    onSelect(SelectedPeriod(year: selected.year, month: month));
    Navigator.of(context).pop();
  }

  List<String> _monthLabels(AppLocalizations lo) => [
    lo.monthsShort0,
    lo.monthsShort1,
    lo.monthsShort2,
    lo.monthsShort3,
    lo.monthsShort4,
    lo.monthsShort5,
    lo.monthsShort6,
    lo.monthsShort7,
    lo.monthsShort8,
    lo.monthsShort9,
    lo.monthsShort10,
    lo.monthsShort11,
  ];

  List<String> _fullMonthLabels(AppLocalizations lo) => [
    lo.months0,
    lo.months1,
    lo.months2,
    lo.months3,
    lo.months4,
    lo.months5,
    lo.months6,
    lo.months7,
    lo.months8,
    lo.months9,
    lo.months10,
    lo.months11,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    final monthLabels = _monthLabels(lo);
    final fullMonths = _fullMonthLabels(lo);

    return SafeArea(
      child: AppContainer(
        color: scheme.sheet,
        border: Border.all(color: scheme.line2, width: 1.0),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
        child: HorizontalPadding(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16.0,
              children: [
                AppContainer(
                  width: 36.0,
                  height: 5.0,
                  color: scheme.dim,
                  borderRadius: BorderRadius.circular(3.0),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lo.period,
                    style: textTheme.headline17Semi.copyWith(
                      color: scheme.ink,
                    ),
                  ),
                ),
                PeriodYearStepper(year: selected.year),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        mainAxisExtent: 44.0,
                      ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final isSelectable =
                        index >= minSelectableMonth &&
                        index <= maxSelectableMonth;
                    return PeriodMonthCell(
                      label: monthLabels[index],
                      isSelected: selected.month == index,
                      isSelectable: isSelectable,
                      onTap: isSelectable ? () => _onPick(context, index) : null,
                    );
                  },
                ),
                Text(
                  lo.periodRange(
                    '${fullMonths[minSelectableMonth]} ${selected.year}',
                    '${fullMonths[maxSelectableMonth]} ${selected.year}',
                  ),
                  textAlign: TextAlign.center,
                  style: textTheme.footnote13.copyWith(color: scheme.ter),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

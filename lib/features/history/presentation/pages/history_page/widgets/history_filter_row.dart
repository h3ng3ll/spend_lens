import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_container.dart';
import 'e_history_filter.dart';
import 'history_filter_chip.dart';

/// The All / Receipts / Cash segmented filter (design_spendlens.md — History
/// artboard's `filters` segment). Local `State` in `HistoryPage`, never bloc
/// state (BLoC rule A3.1) — this widget only reports taps via [onSelected].
class HistoryFilterRow extends StatelessWidget {
  final EHistoryFilter selected;
  final ValueChanged<EHistoryFilter> onSelected;

  const HistoryFilterRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppContainer(
      color: scheme.card,
      border: Border.all(color: scheme.line, width: 1.0),
      borderRadius: BorderRadius.circular(12.0),
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: EHistoryFilter.values
            .map(
              (filter) => Expanded(
                child: HistoryFilterChip(
                  label: _labelFor(lo, filter),
                  isSelected: filter == selected,
                  onTap: () => onSelected(filter),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _labelFor(AppLocalizations lo, EHistoryFilter filter) {
    switch (filter) {
      case EHistoryFilter.all:
        return lo.filterAll;
      case EHistoryFilter.receipts:
        return lo.filterReceipts;
      case EHistoryFilter.cash:
        return lo.filterCash;
    }
  }
}

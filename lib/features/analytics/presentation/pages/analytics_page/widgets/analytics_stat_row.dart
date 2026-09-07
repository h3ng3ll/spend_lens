import 'package:flutter/material.dart';

import 'analytics_stat_tile.dart';

/// The 3-column stat row (Average / Purchases / Cash), laid out as
/// `Expanded` siblings in a `Row` rather than a `GridView` — three fixed
/// children need no grid delegate, and this sidesteps the `childAspectRatio`
/// ban entirely (recorded chronic bug: any `childAspectRatio` overflows at a
/// different device width/text scale).
class AnalyticsStatRow extends StatelessWidget {
  final AnalyticsStatTile average;
  final AnalyticsStatTile purchases;
  final AnalyticsStatTile cash;

  const AnalyticsStatRow({
    super.key,
    required this.average,
    required this.purchases,
    required this.cash,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10.0,
        children: [
          Expanded(child: average),
          Expanded(child: purchases),
          Expanded(child: cash),
        ],
      ),
    );
  }
}

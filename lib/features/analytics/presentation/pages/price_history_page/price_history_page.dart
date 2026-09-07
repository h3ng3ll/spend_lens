import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `PriceHistoryPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell showing one product's price-over-time bar chart across stores.
///
/// M4 minimal placeholder — the real chart (design's v1 bar chart, spec
/// §54–57) and the [IPriceObservationLocalRepository] wiring are M6.
class PriceHistoryPage extends StatelessWidget {
  final String productId;

  const PriceHistoryPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Scaffold(backgroundColor: scheme.bg, appBar: const CustomAppBar());
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `RecordDetailPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell showing one History record (a saved [Receipt] or [Expense]).
///
/// M4 minimal placeholder — the real receipt-vs-cash detail views (edit,
/// delete, view photo) are M5.
class RecordDetailPage extends StatelessWidget {
  final String recordId;

  const RecordDetailPage({super.key, required this.recordId});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: const CustomAppBar(),
      body: Center(
        child: Text(
          recordId,
          style: textTheme.body17.copyWith(color: scheme.ink),
        ),
      ),
    );
  }
}

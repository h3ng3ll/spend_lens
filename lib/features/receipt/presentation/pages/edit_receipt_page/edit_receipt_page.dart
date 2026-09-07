import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `EditReceiptPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell for correcting an already-saved receipt (store/date/items/
/// totals).
///
/// M4 minimal placeholder — the real editable fields, wired to
/// [IReceiptLocalRepository]/[IReceiptItemLocalRepository], are M8.
class EditReceiptPage extends StatelessWidget {
  final String receiptId;

  const EditReceiptPage({super.key, required this.receiptId});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.correctReceipt)),
    );
  }
}

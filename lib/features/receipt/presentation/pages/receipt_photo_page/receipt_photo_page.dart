import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

/// `ReceiptPhotoPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell showing a saved receipt's photo full-screen (view/retake/
/// share/share-from-library).
///
/// M4 minimal placeholder — the real photo view + retake/library/share
/// actions wired to `core/services/receipt_image_store.dart` are M8.
class ReceiptPhotoPage extends StatelessWidget {
  final String receiptId;

  const ReceiptPhotoPage({super.key, required this.receiptId});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: CustomAppBar(title: Text(lo.receiptPhoto)),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// The no-photo state, carrying the designed "Choose from library" action.
///
/// Reached from two distinct conditions — the receipt has no `imagePath` at
/// all, and it names a file that is no longer on disk. Both are genuinely
/// "there is no photo, here is how to add one", so they share this copy
/// rather than one of them surfacing as an error the user cannot act on.
class ReceiptPhotoEmpty extends StatelessWidget {
  final Future<void> Function() onChooseLibrary;

  const ReceiptPhotoEmpty({super.key, required this.onChooseLibrary});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return Center(
      child: HorizontalPadding(
        child: AppEmptyState(
          icon: AppIcons.emptyReceipt,
          title: lo.receiptPhotoEmptyTitle,
          body: lo.receiptPhotoEmptyBody,
          actionLabel: lo.chooseLibrary,
          onAction: onChooseLibrary,
        ),
      ),
    );
  }
}

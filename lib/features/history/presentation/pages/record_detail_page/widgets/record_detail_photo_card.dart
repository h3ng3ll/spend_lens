import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';
import 'record_detail_photo_action.dart';
import 'record_detail_photo_preview.dart';

/// The Receipt photo card (design_spendlens.md — the Record detail
/// artboard's second `dHasItems` branch): the section label, a 150dp
/// preview that opens the photo full-screen on tap, and the
/// Retake / Choose-from-library action pair beneath it.
///
/// Built only for a receipt-sourced record, so it never has to explain the
/// absence of a receipt — only the absence of a PHOTO, which
/// [RecordDetailPhotoPreview] handles.
class RecordDetailPhotoCard extends StatelessWidget {
  final String? filename;
  final VoidCallback onView;
  final Future<void> Function() onRetake;
  final Future<void> Function() onChooseLibrary;

  const RecordDetailPhotoCard({
    super.key,
    required this.filename,
    required this.onView,
    required this.onRetake,
    required this.onChooseLibrary,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10.0,
        children: [
          SectionLabel(text: lo.receiptPhoto),
          RecordDetailPhotoPreview(filename: filename, onView: onView),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: RecordDetailPhotoAction(
                  label: lo.retake,
                  onTap: onRetake,
                ),
              ),
              Expanded(
                child: RecordDetailPhotoAction(
                  label: lo.chooseLibrary,
                  onTap: onChooseLibrary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

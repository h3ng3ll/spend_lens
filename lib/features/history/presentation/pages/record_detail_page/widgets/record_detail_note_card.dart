import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';

/// The Note card (design_spendlens.md — Record detail artboard's `dIsCash`
/// branch): shown only when the expense has a non-empty note. The caller
/// (`RecordDetailPage`) is responsible for that emptiness check — this
/// widget always renders its label + text once built.
class RecordDetailNoteCard extends StatelessWidget {
  final String note;

  const RecordDetailNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.0,
        children: [
          SectionLabel(text: lo.note),
          Text(note, style: textTheme.body17.copyWith(color: scheme.ink)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// Stands in for the receipt photo when none is stored — or when the file
/// has been purged from disk while the receipt still names it (an OS purge,
/// a restore from backup), which is an empty state, not an error.
///
/// Keeping this visible rather than hiding the whole card is deliberate: the
/// card's Retake / Choose-from-library actions are the only way a user can
/// supply an image for a receipt saved without one.
class RecordDetailPhotoPlaceholder extends StatelessWidget {
  final bool isLoading;

  const RecordDetailPhotoPlaceholder({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return AppContainer(
      color: scheme.fieldDim,
      border: Border.all(color: scheme.line2, width: 1.0),
      borderRadius: BorderRadius.circular(14.0),
      alignment: Alignment.center,
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
              lo.receiptPhotoEmptyTitle,
              textAlign: TextAlign.center,
              style: textTheme.footnote13.copyWith(color: scheme.ter),
            ),
    );
  }
}

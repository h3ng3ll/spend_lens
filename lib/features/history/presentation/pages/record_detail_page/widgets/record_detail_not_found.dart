import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';

/// Shown instead of a null-dereference crash when [RecordDetailBloc] resolves
/// `recordId` to nothing — the record was deleted (by this screen's own
/// delete action landing a race, or from elsewhere) before/while this screen
/// was open.
class RecordDetailNotFound extends StatelessWidget {
  const RecordDetailNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return AppEmptyState(
      icon: AppIcons.emptyReceipt,
      title: lo.recordNotFound,
      body: lo.recordNotFoundBody,
    );
  }
}

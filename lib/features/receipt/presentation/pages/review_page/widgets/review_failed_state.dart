import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_icons.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/app_empty_state.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// Shown when Review cannot load a draft — an unusable parse, or a draft
/// that was cleared before this screen mounted.
///
/// It MUST offer a way out. Review is reached from the scanner with `.go()`,
/// which replaces the route stack, so a bare back gesture has nothing to pop
/// to: without an explicit action this state is a hard dead end (spec §66 —
/// the scan flow is never a dead end). [onRetake] clears the stale draft and
/// returns to the scanner, which is the only recovery that makes sense here.
///
/// Reuses the scanner's own failure copy rather than introducing new keys:
/// this is the same event from the user's point of view — "we couldn't read
/// this receipt" — just observed one screen later.
class ReviewFailedState extends StatelessWidget {
  final VoidCallback onRetake;

  const ReviewFailedState({super.key, required this.onRetake});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return Center(
      child: HorizontalPadding(
        child: AppEmptyState(
          icon: AppIcons.emptyReceipt,
          title: lo.scanFailedTitle,
          body: lo.scanFailedTips,
          actionLabel: lo.tryAgain,
          onAction: onRetake,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';

/// The modal scrim shown while an account deletion is in flight.
///
/// Account deletion is not a normal async action. It makes several
/// irreversible round trips in a fixed order — destroy the cloud records,
/// destroy the photos, delete the profile document, delete the Firebase user,
/// then clear the device — and each step assumes the ones before it completed.
/// Left free to navigate, a user can scroll into History, open a record, or
/// trigger a sync against data that is mid-destruction, or start a second
/// irreversible flow on top of this one.
///
/// So the screen is blocked, not merely decorated with a spinner:
///
/// * [AbsorbPointer] swallows every touch beneath the scrim, so nothing in
///   Profile — the back control included — can be operated while the flow
///   runs. `IgnorePointer` would be wrong: it lets taps fall THROUGH to the
///   widgets underneath, which is the opposite of what is needed.
/// * [PopScope] with a literal `canPop: false` absorbs the system back
///   gesture, which no amount of pointer blocking would stop.
///
/// It is deliberately NOT dismissible. There is no cancel affordance because
/// there is nothing safe to cancel into: the remote wipe has already begun,
/// and abandoning the flow midway is precisely the half-deleted state the
/// ordering exists to avoid.
class DeletingAccountOverlay extends StatelessWidget {
  const DeletingAccountOverlay({super.key});

  static const _indicatorSize = 44.0;
  static const _strokeWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return PopScope(
      canPop: false,
      child: AbsorbPointer(
        child: ColoredBox(
          color: scheme.bg.withValues(alpha: 0.88),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20.0,
              children: [
                SizedBox(
                  width: _indicatorSize,
                  height: _indicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth: _strokeWidth,
                    backgroundColor: scheme.accent2Tint,
                    valueColor: AlwaysStoppedAnimation(scheme.accent),
                  ),
                ),
                Text(
                  lo.deletingAccount,
                  textAlign: TextAlign.center,
                  style: textTheme.subhead15.copyWith(color: scheme.sec),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

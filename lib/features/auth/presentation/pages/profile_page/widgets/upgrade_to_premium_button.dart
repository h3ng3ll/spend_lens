import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/services/ui_message_service.dart';
import '../../../../../../core/utils/app_limits.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The Profile artboard's `premiumBtn`.
///
/// Tapping is honest in both directions: when the purchase SDK started, this
/// opens its paywall; when it did not (no API key configured), it says so via
/// a toast instead of silently doing nothing. A button that looks live and
/// does nothing on tap is the defect this codebase repeatedly calls out.
///
/// The prototype's `togglePremium` simulation is deliberately NOT reproduced
/// — design_spendlens.md lists it under "Deliberately not built".
class UpgradeToPremiumButton extends StatelessWidget {
  /// Whether the purchase SDK actually started.
  final bool isPurchaseAvailable;

  /// Opens the paywall. Only called when [isPurchaseAvailable].
  final VoidCallback onUpgrade;

  const UpgradeToPremiumButton({
    super.key,
    required this.isPurchaseAvailable,
    required this.onUpgrade,
  });

  void _onTap(BuildContext context) {
    if (!isPurchaseAvailable) {
      UiMessageService.showInfo(
        AppLocalizations.of(context).purchasesUnavailable,
      );
      return;
    }
    onUpgrade();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => _onTap(context),
      child: AppContainer(
        height: 40.0,
        color: scheme.accentTint,
        border: Border.all(color: scheme.accentLine, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
        alignment: Alignment.center,
        child: Text(
          lo.toPremium(AppLimits.premiumCloudQuotaLabel),
          textAlign: TextAlign.center,
          style: textTheme.footnote13.copyWith(
            color: scheme.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

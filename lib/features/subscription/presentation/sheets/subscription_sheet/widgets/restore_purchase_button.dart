import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';

/// The premium sheet's text-only restore action.
///
/// Not decorative: App Review requires a restore path in any app selling a
/// subscription, so a sheet that can only BUY is a rejection.
///
/// Disabled while a purchase or restore is already running, so a second tap
/// cannot start a concurrent SDK call.
class RestorePurchaseButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const RestorePurchaseButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: textTheme.subhead15.copyWith(
            color: enabled ? scheme.accent : scheme.dim,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

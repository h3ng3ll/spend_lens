import 'package:flutter/material.dart';

import '../resources/app_icons.dart';
import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import 'app_container.dart';
import 'app_svg_icon.dart';

/// The shared destructive-confirm dialog (design_spendlens.md §10 — the
/// delete-all dialog, verified at `SpendLens Prototype.dc.html`'s "DELETE
/// ALL DIALOG" block). Also reused, with different copy, for the category /
/// store delete confirmations.
///
/// CHRONIC BUG GUARD
/// (`db:handler-pops-and-listener-pops-destructive-confirm-pops-twice`):
/// this widget pops **exactly once**, from its own `_onConfirm` /
/// `_onCancel` methods, using `context.pop()`. Callers must NOT ALSO pop
/// after `onConfirm` returns/completes — [onConfirm] is a pure business
/// action (e.g. dispatch a bloc event); it must never itself call
/// `Navigator.pop` on the SAME context this dialog was shown from, or the
/// dialog route AND whatever's behind it both close. See each call site's
/// doc comment for the exact contract it upholds.
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    required String cancelLabel,
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
      ),
    );
  }

  void _onConfirm(BuildContext context) {
    onConfirm();
    Navigator.of(context).pop();
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Dialog(
      backgroundColor: scheme.sheet,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10.0,
          children: [
            Center(
              child: AppContainer(
                width: 48.0,
                height: 48.0,
                color: scheme.warnTint,
                shape: BoxShape.circle,
                alignment: Alignment.center,
                child: AppSvgIcon(
                  asset: AppIcons.warning,
                  color: scheme.warn,
                  size: 24.0,
                ),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headline17Semi.copyWith(color: scheme.ink),
            ),
            Text(
              body,
              textAlign: TextAlign.center,
              style: textTheme.subhead15.copyWith(color: scheme.sec),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () => _onConfirm(context),
                child: AppContainer(
                  height: 52.0,
                  color: scheme.warn,
                  borderRadius: BorderRadius.circular(14.0),
                  alignment: Alignment.center,
                  child: Text(
                    confirmLabel,
                    style: textTheme.headline17.copyWith(
                      color: scheme.bg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onCancel(context),
              child: AppContainer(
                height: 48.0,
                alignment: Alignment.center,
                child: Text(
                  cancelLabel,
                  style: textTheme.headline17.copyWith(
                    color: scheme.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// The inline rename dialog for a custom category (design_spendlens.md's
/// Categories artboard's pencil action) — a small `showDialog` reusing the
/// New-category field's shape rather than a full second page, per the
/// Developer's own call on how to implement rename.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): `showDialog`
/// mounts on the root navigator and Flutter's `Dialog` already repositions
/// itself above `MediaQuery.viewInsets` by construction (unlike a bottom
/// sheet, which does NOT do this automatically) — verified by keeping the
/// dialog's body a single-row `Column` with no fixed height, so it can never
/// be taller than the available above-keyboard space.
class RenameCategoryDialog extends StatefulWidget {
  final String initialName;
  final ValueChanged<String> onRenamed;

  const RenameCategoryDialog({
    super.key,
    required this.initialName,
    required this.onRenamed,
  });

  static Future<void> show(
    BuildContext context, {
    required String initialName,
    required ValueChanged<String> onRenamed,
  }) {
    return showDialog<void>(
      context: context,
      // Root navigator, above the 5-tab shell — see `CurrencySheet.show`.
      // `CategoriesPageRoute` is already a top-level route above the shell,
      // so nothing is broken today; the flag keeps this correct if the page
      // is ever moved into a shell branch.
      useRootNavigator: true,
      builder: (_) => RenameCategoryDialog(
        initialName: initialName,
        onRenamed: onRenamed,
      ),
    );
  }

  @override
  State<RenameCategoryDialog> createState() => _RenameCategoryDialogState();
}

class _RenameCategoryDialogState extends State<RenameCategoryDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCancel() => Navigator.of(context).pop();

  void _onSave() {
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) return;
    widget.onRenamed(trimmed);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: scheme.sheet,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12.0,
          children: [
            Text(
              lo.renameCategory,
              textAlign: TextAlign.center,
              style: textTheme.headline17Semi.copyWith(color: scheme.ink),
            ),
            CustomTextField(
              controller: _controller,
              hintText: lo.newCatPh,
              style: textTheme.body17.copyWith(color: scheme.ink),
              hintStyle: textTheme.body17.copyWith(color: scheme.ter),
              fillColor: scheme.field,
              filled: true,
              isDense: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onSave(),
              borderRadius: BorderRadius.circular(14.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            GestureDetector(
              onTap: _onSave,
              child: AppContainer(
                height: 52.0,
                color: scheme.accent,
                borderRadius: BorderRadius.circular(14.0),
                alignment: Alignment.center,
                child: Text(
                  lo.save,
                  style: textTheme.headline17.copyWith(
                    color: scheme.onAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _onCancel,
              child: AppContainer(
                height: 48.0,
                alignment: Alignment.center,
                child: Text(
                  lo.cancel,
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

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

/// Review's inline item editor (`SpendLens Prototype.dc.html` line 502): a
/// warning-tinted card with a name field and a "Done" close action.
///
/// `db:textfield-loses-focus-on-keystroke` / `-ontapoutside-submits-stale-
/// prop` — this field uses a PERSISTENT [controller] the parent page owns
/// (never a `key: ValueKey(value)` + `initialValue:` pairing), and
/// [onDone] reads the controller's live text at commit time, not a
/// build-time prop.
class ReviewItemEditRow extends StatelessWidget {
  final TextEditingController controller;
  final String hintLabel;
  final String doneLabel;
  final VoidCallback onDone;

  const ReviewItemEditRow({
    super.key,
    required this.controller,
    required this.hintLabel,
    required this.doneLabel,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return AppContainer(
      color: scheme.warnTint,
      borderRadius: BorderRadius.circular(14.0),
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hintLabel,
                style: textTheme.footnote13.copyWith(
                  color: scheme.warn,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onDone,
                child: Text(
                  doneLabel,
                  style: textTheme.subhead15.copyWith(
                    color: scheme.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          CustomTextField(
            controller: controller,
            fillColor: scheme.field,
            filled: true,
            style: textTheme.headline17.copyWith(color: scheme.ink),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onDone(),
          ),
        ],
      ),
    );
  }
}

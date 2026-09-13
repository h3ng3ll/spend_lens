import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';

/// One destructive choice in [DeleteAccountSheet]: a title plus the body that
/// spells out exactly what goes and what stays.
///
/// The body is not optional decoration — it is how the user tells the two
/// scopes apart, and a title alone ("Delete everywhere") would leave them
/// guessing at the difference before an irreversible action.
class DeleteAccountOptionRow extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback onTap;

  const DeleteAccountOptionRow({
    super.key,
    required this.title,
    required this.body,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: HorizontalPadding(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 4.0,
            children: [
              Text(
                title,
                style: textTheme.body17.copyWith(
                  color: scheme.warn,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                body,
                style: textTheme.footnote13.copyWith(color: scheme.sec),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

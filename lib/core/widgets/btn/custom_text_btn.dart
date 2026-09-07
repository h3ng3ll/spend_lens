import 'package:flutter/material.dart';

import '../../resources/colors/app_color_scheme.dart';
import '../../resources/text/app_text_theme.dart';

class CustomTextBtn extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Widget? child;

  const CustomTextBtn({
    super.key,
    this.text,
    required this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return TextButton(
      onPressed: onPressed,
      child: child ??
          Text(
            text!,
            style: textTheme.subhead15.copyWith(
              color: colorScheme.sec,
            ),
          ),
    );
  }
}

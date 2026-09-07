import 'package:flutter/material.dart';

import '../../resources/colors/app_color_scheme.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/text/app_text_theme.dart';

class TranslucentBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final EdgeInsets? padding;
  final Map<WidgetState, Color> colors;
  final Color? anyStateColor;
  final String? text;
  final BorderSide? border;
  final BorderRadius? borderRadius;

  const TranslucentBtn({
    super.key,
    required this.onPressed,
    this.child,
    this.padding,
    this.colors = const {},
    this.anyStateColor,
    this.text,
    this.border,
    this.borderRadius,
  }) : assert(
          text != null || child != null,
        );

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final isActive = onPressed != null;

    final color = isActive
        ? colorScheme.ink
        : colorScheme.ink.withValues(
            alpha: 0.4,
          );

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              if (colors.containsKey(WidgetState.disabled)) {
                return colors[WidgetState.disabled]!;
              }
              return AppColors.white.value.withValues(
                alpha: 0.1,
              );
            }
            if (anyStateColor != null) {
              return anyStateColor!;
            }
            return AppColors.white.value.withValues(
              alpha: 0.2,
            );
          },
        ),
        foregroundColor: WidgetStateProperty.all(
          colorScheme.ink,
        ),
        shadowColor: WidgetStateProperty.all(
          AppColors.transparent.value,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            side: border ??
                BorderSide(
                  width: 1,
                  color: AppColors.white.value.withValues(
                    alpha: 0.2,
                  ),
                ),
            borderRadius: borderRadius ??
                BorderRadius.circular(
                  20.0,
                ),
          ),
        ),
        padding: WidgetStateProperty.all(
          padding ??
              const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
        ),
      ),
      child: text == null
          ? child
          : Text(
              text!,
              style: textTheme.subhead15.copyWith(
                color: color,
              ),
            ),
    );
  }
}

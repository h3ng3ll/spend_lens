import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/colors/app_color_scheme.dart';
import '../resources/colors/app_colors.dart';
import '../resources/text/app_text_theme.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final TextEditingController? controller;
  final bool? obscureText;
  final String obscuringCharacter;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final Widget? prefixIcon;

  /// Sizing box for [prefixIcon]. Left null, `InputDecoration` applies
  /// Material's 48x48 minimum touch target and a smaller icon scales up to
  /// fill it, so a caller wanting the icon at its stated size must pass
  /// constraints here.
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final TextStyle? hintStyle;
  final String counterText;
  final EdgeInsets? padding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? border;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final BorderRadius borderRadius;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final bool readOnly;
  final bool? filled;
  final TextStyle? style;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final bool? isDense;
  final FocusNode? focusNode;

  CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.obscureText,
    this.initialValue,
    this.onChanged,
    this.obscuringCharacter = '*',
    this.textInputAction,
    this.validator,
    this.prefix,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.minLines,
    this.counterText = '',
    this.suffixIcon,
    this.suffix,
    this.hintStyle,
    this.padding,
    this.onTapOutside,
    this.focusedBorder,
    this.enabledBorder,
    this.textAlign,
    this.inputFormatters,
    BorderRadius? borderRadius,
    this.fillColor,
    this.enabledBorderColor,
    this.onTap,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.style,
    this.scrollController,
    this.scrollPhysics,
    this.filled,
    this.isDense,
    this.errorBorder,
    this.border,
    this.focusNode,
  }) : borderRadius = borderRadius ??
            BorderRadius.circular(
              12.0,
            );

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);

    final textTheme = AppTextTheme.of(context);
    return TextFormField(
      obscureText: obscureText ?? false,
      readOnly: readOnly,
      maxLines: maxLines,
      style: style ??
          textTheme.body17.copyWith(
            color: colorScheme.ink,
            wordSpacing: 2.0,
          ),
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      obscuringCharacter: obscuringCharacter,
      keyboardType: keyboardType,
      initialValue: initialValue,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside ??
          (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction ?? TextInputAction.next,
      controller: controller,
      maxLength: maxLength,
      minLines: minLines,
      textAlign: textAlign ?? TextAlign.start,
      contextMenuBuilder: (context, editableTextState) {
        return AdaptiveTextSelectionToolbar(
          anchors: editableTextState.contextMenuAnchors,
          children: editableTextState.contextMenuButtonItems.map((
            ContextMenuButtonItem buttonItem,
          ) {
            return CupertinoButton(
              borderRadius: null,
              color: colorScheme.sec,
              onPressed: buttonItem.onPressed,
              padding: const EdgeInsets.all(10.0),
              pressedOpacity: 0.7,
              child: SizedBox(
                child: Text(
                  CupertinoTextSelectionToolbarButton.getButtonLabel(
                    context,
                    buttonItem,
                  ),
                  style: textTheme.body17.copyWith(
                    color: AppColors.black.value,
                    wordSpacing: 2.0,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
      focusNode: focusNode,
      decoration: InputDecoration(
        filled: filled ?? true,
        isDense: isDense,
        counterText: counterText,
        fillColor: fillColor ??
            AppColors.white.value.withValues(
              alpha: 0.15,
            ),
        hintText: hintText,
        contentPadding: padding ??
            EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 7.0,
            ),
        hintStyle: hintStyle ??
            textTheme.body17.copyWith(
              color: AppColors.white.value.withValues(
                alpha: 0.6,
              ),
            ),
        labelText: labelText,
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.white.value.withValues(
                  alpha: 0.2,
                ),
                width: 0.5,
              ),
              borderRadius: borderRadius,
            ),
        border: border ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.accent,
              ),
              borderRadius: borderRadius,
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.accentDark.value,
                width: 0.5,
              ),
              borderRadius: borderRadius,
            ),
        errorBorder: errorBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.onError,
              ),
              borderRadius: borderRadius,
            ),
        errorStyle: textTheme.body17.copyWith(
          color: colorScheme.onError,
        ),
        prefix: prefix,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIconConstraints,
        suffix: suffix,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

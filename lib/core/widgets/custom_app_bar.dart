import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/app_icons.dart';
import '../resources/colors/app_color_scheme.dart';
import '../resources/colors/app_colors.dart';
import '../utils/extensions/go_router_x.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final double? height;
  final double? leadingWidth;
  final EdgeInsetsGeometry? actionsPadding;
  final bool centerTitle;
  final Widget? title;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final bool? forceMaterialTransparency;
  final Color? shadowColor;

  /// Whether a back-arrow affordance may be synthesized when [leading] is
  /// not supplied. Defaults to `true` for pushed/detail screens, which have
  /// something to pop back to. A screen that is the ROOT of a
  /// `StatefulShellRoute` branch (a bottom-tab root) has nothing to pop —
  /// `context.goBack` would instead jump to an unrelated tab — so that
  /// caller MUST pass `false` (R2-4).
  final bool canGoBack;

  const CustomAppBar({
    super.key,
    this.actions,
    this.leading,
    this.leadingWidth = 60,
    this.actionsPadding = const EdgeInsets.symmetric(
      horizontal: 25.0,
    ),
    this.height = 80.0,
    this.centerTitle = true,
    this.title,
    this.backgroundColor,
    this.shape,
    this.forceMaterialTransparency,
    this.shadowColor,
    this.canGoBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final iconColor = colorScheme.ink;

    final resolvedLeading = leading ??
        (canGoBack
            ? InkWell(
                onTap: context.goBack,
                child: SvgPicture.asset(
                  AppIcons.arrowLeftOutlined,
                  width: 24.0,
                  height: 24.0,
                  colorFilter: ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null);

    return AppBar(
      leadingWidth: leadingWidth,
      title: title,
      centerTitle: centerTitle,
      forceMaterialTransparency: forceMaterialTransparency ?? false,
      shadowColor: shadowColor,
      iconTheme: IconThemeData(color: iconColor),
      actionsIconTheme: IconThemeData(color: iconColor),
      foregroundColor: iconColor,
      automaticallyImplyLeading: false,
      leading: resolvedLeading == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: Center(child: resolvedLeading),
            ),
      actionsPadding: actionsPadding,
      backgroundColor: backgroundColor ?? AppColors.transparent.value,
      toolbarHeight: height ?? 120,
      actions: actions,
      shape: shape,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        height ?? 110.0,
      );
}

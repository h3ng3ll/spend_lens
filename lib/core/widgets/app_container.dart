import 'package:flutter/material.dart';

/// The single decorated-box primitive for the app.
///
/// Every screen/widget that needs a colored/rounded/bordered/shadowed box
/// uses this instead of a raw `Container(decoration: BoxDecoration(...))` or
/// `ClipRRect` (both banned project-wide, per CLAUDE.md's hard bans list).
/// Centralizing it here means a later design-token change (radius, shadow
/// recipe) is a one-file edit.
class AppContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final BoxShape shape;
  final Clip clipBehavior;
  final AlignmentGeometry? alignment;

  const AppContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.shape = BoxShape.rectangle,
    this.clipBehavior = Clip.antiAlias,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final hasShadow = boxShadow != null && boxShadow!.isNotEmpty;

    // A `decoration` border INSETS the child by its width, so a 96px circle
    // with a 3px border lays its child out at 90px and centres it. The clip
    // path is still the full 96px circle, so it is LARGER than the child and
    // never bites: a photo renders as a square with barely-rounded corners
    // instead of a circle — the reported "cropped on the left and right".
    //
    // Drawing the border as a FOREGROUND decoration keeps the child at full
    // size, so the clip actually crops it, and paints the border over the
    // image edge where an avatar ring belongs. Only done when there is a
    // child to clip; a plain bordered box is unaffected.
    final drawBorderOnTop =
        border != null && child != null && clipBehavior != Clip.none;

    final decoratedBox = Container(
      width: width,
      height: height,
      padding: padding,
      margin: hasShadow ? null : margin,
      alignment: alignment,
      clipBehavior: hasShadow ? Clip.none : clipBehavior,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        shape: shape,
        border: drawBorderOnTop ? null : border,
        boxShadow: hasShadow ? null : boxShadow,
      ),
      foregroundDecoration: drawBorderOnTop
          ? BoxDecoration(
              borderRadius: shape == BoxShape.circle ? null : borderRadius,
              shape: shape,
              border: border,
            )
          : null,
      child: child,
    );

    if (!hasShadow) {
      return decoratedBox;
    }

    // Shadow lives on an unclipped outer box; fill+border+clip+child stay on
    // the inner one — clipping the two together crops the shadow (recorded
    // global bug: boxshadow-cropped-by-clipbehavior-same-container).
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        shape: shape,
        boxShadow: boxShadow,
      ),
      child: decoratedBox,
    );
  }
}

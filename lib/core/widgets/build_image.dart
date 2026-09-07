import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/app_icons.dart';
import '../resources/colors/app_color_scheme.dart';
import 'app_container.dart';

/// Renders a local (asset/memory) image, or a placeholder person glyph when
/// no image is set.
///
/// Note: sinergy_hub's version also supported a `url` (network) source via
/// `cached_network_image`, which design_spendlens.md §2 lists as deliberately
/// absent — receipt/product images in this app are always local files
/// (`core/services/receipt_image_store.dart`, M3+) or in-memory bytes, never
/// remote URLs, so that branch is dropped rather than carried forward dead.
class BuildImage extends StatelessWidget {
  final Uint8List? bytes;
  final String? asset;
  final double? width;
  final double? height;

  final BoxShape shape;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Border? border;

  const BuildImage({
    super.key,
    this.bytes,
    this.asset,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.border,
  });

  bool get _hasImage => bytes != null || asset != null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);

    if (!_hasImage) {
      return _placeholder(colorScheme);
    }

    final Widget image = bytes != null
        ? Image.memory(bytes!, fit: fit)
        : Image.asset(asset!, fit: fit);

    return _wrap(image);
  }

  Widget _wrap(Widget child) {
    return AppContainer(
      width: width,
      height: height,
      shape: shape,
      borderRadius: shape == BoxShape.circle ? null : borderRadius,
      border: border,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _placeholder(AppColorScheme colorScheme) {
    return Center(
      child: SvgPicture.asset(
        AppIcons.user,
        width: 40,
        height: 40,
        colorFilter: ColorFilter.mode(
          colorScheme.ink.withValues(alpha: 0.6),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

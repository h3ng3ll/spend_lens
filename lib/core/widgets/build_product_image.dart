import 'dart:io';

import 'package:flutter/material.dart';

import '../di/injection.dart';
import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import '../services/product_image_store/product_image_store.dart';
import 'app_container.dart';
import 'build_image.dart';

/// Renders a product's photo from its FILENAME, falling back to the
/// product's initial letter on an accent tile.
///
/// Exists so no caller has to hold image bytes to show a product. States
/// carry the filename; this resolves it against the current Documents
/// directory — which moves across iOS reinstalls, so the path cannot be
/// stored — and hands a `File` to [BuildImage].
///
/// Deliberately a near-twin of `BuildStoreLogo` rather than a shared
/// abstraction over it: the two differ only in which image store they
/// resolve against, and collapsing them would couple the product and store
/// slices through a widget for no behavioural gain. `ReceiptImageStore` sets
/// the same precedent.
class BuildProductImage extends StatefulWidget {
  /// Filename as stored on `Product.imageFilename`. Empty renders the
  /// initial.
  final String filename;

  /// Drawn when there is no photo. Empty renders `?`.
  final String productName;
  final double size;
  final Border? border;

  const BuildProductImage({
    super.key,
    required this.filename,
    required this.productName,
    required this.size,
    this.border,
  });

  @override
  State<BuildProductImage> createState() => _BuildProductImageState();
}

class _BuildProductImageState extends State<BuildProductImage> {
  /// The resolved file PLUS the modification stamp it was resolved at.
  ///
  /// The stamp is what makes a re-pick visible. Both image slots are fixed
  /// filenames overwritten in place (`ProductImageStore`), so picking a
  /// second photo changes neither the filename nor the path: without reading
  /// something that actually moves, the widget has no way to tell that the
  /// bytes behind an identical `String` are now a different image, and it
  /// silently keeps showing the first pick.
  late Future<_ResolvedImage> _resolved = _resolve();

  /// The most recent successful resolution, shown while a re-resolve is in
  /// flight so the photo never blinks back to the initial tile.
  _ResolvedImage? _lastResolved;

  /// Re-resolved on EVERY update, not only when the filename changed — the
  /// filename staying identical is precisely what a re-pick looks like, so an
  /// `oldWidget.filename != widget.filename` guard would skip the one case
  /// this widget exists to catch.
  @override
  void didUpdateWidget(covariant BuildProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolved = _resolve();
  }

  Future<_ResolvedImage> _resolve() async {
    final file = await getIt<ProductImageStore>().resolve(widget.filename);
    if (file == null) return _remember(const _ResolvedImage(null, null));
    try {
      return _remember(_ResolvedImage(file, await file.lastModified()));
    } catch (_) {
      return _remember(_ResolvedImage(file, null));
    }
  }

  /// Recorded as the future completes rather than inside `builder`, so the
  /// fallback is never written as a side effect of a build.
  _ResolvedImage _remember(_ResolvedImage resolved) {
    _lastResolved = resolved;
    return resolved;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filename.isEmpty) return _initialTile(context);

    return FutureBuilder<_ResolvedImage>(
      future: _resolved,
      builder: (context, snapshot) {
        // Falls back to the previous resolution while the new one is in
        // flight: a re-pick re-resolves on every rebuild, and rendering the
        // initial tile for those frames would flash a letter over a photo
        // that is about to be replaced by another photo.
        final resolved = snapshot.data ?? _lastResolved;
        final file = resolved?.file;
        if (file == null) return _initialTile(context);

        return BuildImage(
          // Keyed on the modification stamp so replacing the bytes behind an
          // unchanged path rebuilds the `Image` against the freshly-evicted
          // cache entry, instead of reusing the element that already holds
          // the previous frame.
          key: ValueKey('${widget.filename}:${snapshot.data?.modifiedAt}'),
          file: file,
          width: widget.size,
          height: widget.size,
          shape: BoxShape.circle,
          border: widget.border,
        );
      },
    );
  }

  Widget _initialTile(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final name = widget.productName;

    return AppContainer(
      width: widget.size,
      height: widget.size,
      color: scheme.accentTint,
      shape: BoxShape.circle,
      border: widget.border,
      alignment: Alignment.center,
      child: Text(
        name.isEmpty ? '?' : name[0].toUpperCase(),
        style: textTheme.headline17Semi.copyWith(color: scheme.accent),
      ),
    );
  }
}

/// A resolved image file and the modification stamp it carried when resolved.
class _ResolvedImage {
  final File? file;
  final DateTime? modifiedAt;

  const _ResolvedImage(this.file, this.modifiedAt);
}

import 'dart:io';

import 'package:flutter/material.dart';

import '../di/injection.dart';
import '../resources/colors/app_color_scheme.dart';
import '../resources/text/app_text_theme.dart';
import '../services/store_logo_image_store/store_logo_image_store.dart';
import 'app_container.dart';
import 'build_image.dart';

/// Renders a store's logo from its FILENAME, falling back to the store's
/// initial letter on an accent tile.
///
/// Exists so no caller has to hold logo bytes to show a mark. States carry the
/// filename; this resolves it against the current Documents directory — which
/// moves across iOS reinstalls, so the path cannot be stored — and hands a
/// `File` to [BuildImage].
///
/// The initial-letter fallback is the same tile [StoreListRow] already draws,
/// so a store without a logo looks exactly as it did before logos existed.
class BuildStoreLogo extends StatefulWidget {
  /// Filename as stored on `Store.logoFilename`. Empty renders the initial.
  final String filename;

  /// Drawn when there is no logo. Empty renders `?`.
  final String storeName;
  final double size;
  final Border? border;

  const BuildStoreLogo({
    super.key,
    required this.filename,
    required this.storeName,
    required this.size,
    this.border,
  });

  @override
  State<BuildStoreLogo> createState() => _BuildStoreLogoState();
}

class _BuildStoreLogoState extends State<BuildStoreLogo> {
  /// The resolved file PLUS the modification stamp it was resolved at.
  ///
  /// The stamp is what makes a re-pick visible. Both logo slots are fixed
  /// filenames overwritten in place (`StoreLogoImageStore`), so picking a
  /// second photo changes neither the filename nor the path: without reading
  /// something that actually moves, the widget has no way to tell that the
  /// bytes behind an identical `String` are now a different image, and it
  /// silently keeps showing the first pick.
  late Future<_ResolvedLogo> _resolved = _resolve();

  /// The most recent successful resolution, shown while a re-resolve is in
  /// flight so the logo never blinks back to the initial tile.
  _ResolvedLogo? _lastResolved;

  /// Re-resolved on EVERY update, not only when the filename changed — the
  /// filename staying identical is precisely what a re-pick looks like, so an
  /// `oldWidget.filename != widget.filename` guard would skip the one case
  /// this widget exists to catch. The cost is a `stat` per parent rebuild, and
  /// the parent only rebuilds on a bloc emit.
  @override
  void didUpdateWidget(covariant BuildStoreLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolved = _resolve();
  }

  Future<_ResolvedLogo> _resolve() async {
    final file = await getIt<StoreLogoImageStore>().resolve(widget.filename);
    if (file == null) return _remember(const _ResolvedLogo(null, null));
    try {
      return _remember(_ResolvedLogo(file, await file.lastModified()));
    } catch (_) {
      return _remember(_ResolvedLogo(file, null));
    }
  }

  /// Recorded as the future completes rather than inside `builder`, so the
  /// fallback is never written as a side effect of a build.
  _ResolvedLogo _remember(_ResolvedLogo resolved) {
    _lastResolved = resolved;
    return resolved;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filename.isEmpty) return _initialTile(context);

    return FutureBuilder<_ResolvedLogo>(
      future: _resolved,
      builder: (context, snapshot) {
        // Falls back to the previous resolution while the new one is in
        // flight: a re-pick re-resolves on every rebuild, and rendering the
        // initial tile for those frames would flash a letter over a logo that
        // is about to be replaced by another logo.
        final resolved = snapshot.data ?? _lastResolved;
        final file = resolved?.file;
        if (file == null) return _initialTile(context);

        return BuildImage(
          // Keyed on the modification stamp so replacing the bytes behind an
          // unchanged path rebuilds the `Image` against the freshly-evicted
          // cache entry, instead of reusing the element that already holds the
          // previous frame.
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
    final name = widget.storeName;

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

/// A resolved logo file and the modification stamp it carried when resolved.
class _ResolvedLogo {
  final File? file;
  final DateTime? modifiedAt;

  const _ResolvedLogo(this.file, this.modifiedAt);
}

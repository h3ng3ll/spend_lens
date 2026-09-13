import 'dart:io';

import 'package:flutter/material.dart';

import '../di/injection.dart';
import '../services/avatar_image_store/avatar_image_store.dart';
import 'build_image.dart';

/// Renders the stored avatar from its FILENAME, or the placeholder glyph.
///
/// Exists so no caller has to hold avatar bytes to show a face. States carry
/// the filename; this resolves it against the current Documents directory —
/// which moves across iOS reinstalls, so the path cannot be stored — and hands
/// a `File` to [BuildImage].
///
/// The resolution is a `FutureBuilder` rather than a bloc read because it is
/// pure filesystem I/O with no business meaning, and because keeping it here
/// means the four avatar surfaces share one implementation.
class BuildAvatar extends StatefulWidget {
  /// Filename as stored on the profile. Empty renders the placeholder.
  final String filename;
  final double size;
  final Border? border;

  const BuildAvatar({
    super.key,
    required this.filename,
    required this.size,
    this.border,
  });

  @override
  State<BuildAvatar> createState() => _BuildAvatarState();
}

class _BuildAvatarState extends State<BuildAvatar> {
  /// The resolved file PLUS the modification stamp it was resolved at.
  ///
  /// The stamp is what makes a re-pick visible. Both avatar slots are fixed
  /// filenames overwritten in place (`AvatarImageStore`), so picking a second
  /// photo changes neither the filename nor the path: without reading
  /// something that actually moves, the widget has no way to tell that the
  /// bytes behind an identical `String` are now a different image, and the
  /// avatar silently keeps showing the first pick.
  late Future<_ResolvedAvatar> _resolved = _resolve();

  /// The most recent successful resolution, shown while a re-resolve is in
  /// flight so the avatar never blinks back to the placeholder.
  _ResolvedAvatar? _lastResolved;

  /// Re-resolved on EVERY update, not only when the filename changed — the
  /// filename staying identical is precisely what a re-pick looks like, so a
  /// `oldWidget.filename != widget.filename` guard would skip the one case
  /// this widget exists to catch. The cost is a `stat` per parent rebuild,
  /// and the parent only rebuilds on a bloc emit.
  @override
  void didUpdateWidget(covariant BuildAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolved = _resolve();
  }

  Future<_ResolvedAvatar> _resolve() async {
    final file = await getIt<AvatarImageStore>().resolve(widget.filename);
    if (file == null) return _remember(const _ResolvedAvatar(null, null));
    try {
      return _remember(_ResolvedAvatar(file, await file.lastModified()));
    } catch (_) {
      return _remember(_ResolvedAvatar(file, null));
    }
  }

  /// Recorded as the future completes rather than inside `builder`, so the
  /// fallback is never written as a side effect of a build.
  _ResolvedAvatar _remember(_ResolvedAvatar resolved) {
    _lastResolved = resolved;
    return resolved;
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = BuildImage(
      width: widget.size,
      height: widget.size,
      shape: BoxShape.circle,
      border: widget.border,
    );

    if (widget.filename.isEmpty) return placeholder;

    return FutureBuilder<_ResolvedAvatar>(
      future: _resolved,
      builder: (context, snapshot) {
        // Falls back to the previous resolution while the new one is in
        // flight: a re-pick re-resolves on every rebuild, and rendering the
        // placeholder for those frames would flash an empty circle over an
        // avatar that is about to be replaced by another avatar.
        final resolved = snapshot.data ?? _lastResolved;
        final file = resolved?.file;
        if (file == null) return placeholder;

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
}

/// A resolved avatar file and the modification stamp it carried when resolved.
class _ResolvedAvatar {
  final File? file;
  final DateTime? modifiedAt;

  const _ResolvedAvatar(this.file, this.modifiedAt);
}

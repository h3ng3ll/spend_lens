import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../../../../core/widgets/app_container.dart';
import 'record_detail_photo_placeholder.dart';
import 'record_detail_photo_thumb.dart';

/// The 150dp preview inside Record Detail's receipt-photo card
/// (design_spendlens.md — the artboard's `openPhoto` target): the stored
/// photo when there is one, the dashed placeholder when there is not.
///
/// Reads BYTES through a `FutureBuilder` keyed on [filename], never
/// `Image.file` — the same deliberate choice `ReceiptPhotoView` documents:
/// `ReceiptImageStore` writes a STABLE per-receipt filename
/// (`receipt_<id>.jpg`), so replacing a photo overwrites the same path, and
/// `FileImage` caches on path identity — an unkeyed `Image.file` would keep
/// painting the OLD photo after a successful replace, with no error to show
/// for it.
///
/// Only tappable once bytes exist: opening the full-screen viewer on a
/// receipt with no photo would push a screen with nothing to show.
class RecordDetailPhotoPreview extends StatelessWidget {
  static const _previewHeight = 150.0;

  final String? filename;
  final VoidCallback onView;

  const RecordDetailPhotoPreview({
    super.key,
    required this.filename,
    required this.onView,
  });

  Future<Uint8List?> _readBytes() async {
    final name = filename;
    if (name == null || name.isEmpty) return null;
    final File? file = await getIt<ReceiptImageStore>().resolve(name);
    if (file == null) return null;
    return file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      key: ValueKey(filename),
      future: _readBytes(),
      builder: (context, snapshot) {
        final bytes = snapshot.data;

        return GestureDetector(
          onTap: bytes == null ? null : onView,
          child: AppContainer(
            height: _previewHeight,
            borderRadius: BorderRadius.circular(14.0),
            child: bytes == null
                ? RecordDetailPhotoPlaceholder(
                    isLoading: snapshot.connectionState != ConnectionState.done,
                  )
                : RecordDetailPhotoThumb(bytes: bytes),
          ),
        );
      },
    );
  }
}

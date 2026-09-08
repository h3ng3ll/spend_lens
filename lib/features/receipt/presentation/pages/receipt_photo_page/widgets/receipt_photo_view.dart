import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import 'receipt_photo_empty.dart';

/// Resolves the stored receipt photo and renders it, with the designed
/// "Choose from library" action beneath it for replacing it.
///
/// The `FutureBuilder` is keyed on [filename] and reads BYTES rather than
/// using `Image.file`. Both are deliberate: `ReceiptImageStore` writes a
/// STABLE per-receipt filename (`receipt_<id>.jpg`), so a replace overwrites
/// the same path — and `FileImage` caches on path identity, which means an
/// unkeyed `Image.file` would keep painting the OLD decoded image after a
/// successful replace, with no error to show for it.
class ReceiptPhotoView extends StatelessWidget {
  final String filename;
  final Future<void> Function() onChooseLibrary;

  const ReceiptPhotoView({
    super.key,
    required this.filename,
    required this.onChooseLibrary,
  });

  Future<Uint8List?> _readBytes() async {
    final File? file = await getIt<ReceiptImageStore>().resolve(filename);
    if (file == null) return null;
    return file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return FutureBuilder<Uint8List?>(
      key: ValueKey(filename),
      future: _readBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final bytes = snapshot.data;

        // The file is gone from disk (an OS purge, a restore from backup)
        // while the receipt still names it — an empty state, not an error.
        if (bytes == null) {
          return ReceiptPhotoEmpty(onChooseLibrary: onChooseLibrary);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            Expanded(
              child: InteractiveViewer(
                maxScale: 4.0,
                child: Center(
                  child: Image.memory(bytes, fit: BoxFit.contain),
                ),
              ),
            ),
            HorizontalPadding(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: GestureDetector(
                  onTap: onChooseLibrary,
                  behavior: HitTestBehavior.opaque,
                  child: AppContainer(
                    color: scheme.card,
                    border: Border.all(color: scheme.line, width: 1.0),
                    borderRadius: BorderRadius.circular(14.0),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      lo.chooseLibrary,
                      textAlign: TextAlign.center,
                      style: textTheme.subhead15.copyWith(color: scheme.ink),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

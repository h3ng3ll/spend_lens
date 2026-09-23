import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/section_label.dart';

/// The Receipt photo card on Review — the same card Record Detail shows,
/// so the user can check the parsed items against the exact region the
/// scanner cropped and read, BEFORE saving.
///
/// Renders the whole image at full card width and its natural aspect
/// (`BoxFit.fitWidth`), never a `cover` thumbnail: the point here is to
/// see every line OCR saw, and a cover crop would hide the frame's edges.
///
/// Reads BYTES through a `FutureBuilder` keyed on [filename], for the same
/// reason `RecordDetailPhotoPreview` documents: `FileImage` caches on path
/// identity, and a retake can reuse a path.
class ReviewPhotoCard extends StatelessWidget {
  static const _placeholderHeight = 150.0;

  final String filename;

  const ReviewPhotoCard({super.key, required this.filename});

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

    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10.0,
        children: [
          SectionLabel(text: lo.receiptPhoto),
          FutureBuilder<Uint8List?>(
            key: ValueKey(filename),
            future: _readBytes(),
            builder: (context, snapshot) {
              final bytes = snapshot.data;
              if (bytes != null) {
                return AppContainer(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Image.memory(bytes, fit: BoxFit.fitWidth),
                );
              }

              return AppContainer(
                height: _placeholderHeight,
                color: scheme.fieldDim,
                border: Border.all(color: scheme.line2, width: 1.0),
                borderRadius: BorderRadius.circular(14.0),
                alignment: Alignment.center,
                child: snapshot.connectionState != ConnectionState.done
                    ? const CircularProgressIndicator()
                    : Text(
                        lo.receiptPhotoEmptyTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.footnote13.copyWith(
                          color: scheme.ter,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

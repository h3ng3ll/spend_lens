import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';

/// The stored receipt photo as it appears in Record Detail's photo card,
/// with the design's "View" pill over its lower-right corner.
class RecordDetailPhotoThumb extends StatelessWidget {
  final Uint8List bytes;

  const RecordDetailPhotoThumb({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(bytes, fit: BoxFit.cover),
        Positioned(
          right: 10.0,
          bottom: 10.0,
          child: AppContainer(
            height: 26.0,
            color: scheme.toastBg,
            borderRadius: BorderRadius.circular(999.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.center,
            child: Text(
              lo.view,
              style: textTheme.sectionLabel12.copyWith(
                color: scheme.toastInk,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/routes/presentation/error_message_widget.dart';
import '../../../../../../core/routes/presentation/loading_data_widget.dart';
import '../../../../../../core/services/sync_status_presenter/sync_status_presenter.dart';
import '../../../../../../core/utils/byte_format.dart';
import '../../../../../../core/widgets/app_section_card.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../../core/widgets/settings_row.dart';
import '../../../bloc/receipt_storage_bloc/receipt_storage_bloc.dart';

/// What one receipt costs: its photo, its record data, and whether the
/// photo has reached the cloud.
///
/// The two sizes are shown SEPARATELY rather than summed. Only the photo
/// occupies the Firebase Storage quota Profile's bar measures; the record
/// lives in Firestore and is accounted differently. A single total would
/// imply the two draw on one budget, so the footnote states which is which
/// — that note is what keeps the two figures honest.
class ReceiptStorageBody extends StatelessWidget {
  static const _syncStatusPresenter = SyncStatusPresenter();

  final ReceiptStorageState state;

  const ReceiptStorageBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    if (state.isFailed) {
      return ErrorMessageWidget(message: state.errorMessage);
    }

    if (state.isNotFound) {
      return Center(child: Text(lo.recordNotFound));
    }

    final info = state.info;
    if (!state.isReady || info == null) {
      return const LoadingDataWidget();
    }

    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            AppSectionCard(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsRow(
                    label: lo.syncStatus,
                    trailingText: _syncStatusPresenter.label(
                      info.syncStatus,
                      lo,
                    ),
                    trailingTextColor: _syncStatusPresenter.color(
                      info.syncStatus,
                      scheme,
                    ),
                    showChevron: false,
                  ),
                  SettingsRow(
                    label: lo.photoSize,
                    trailingText: info.hasPhoto
                        ? formatBytes(info.photoBytes)
                        : lo.noPhotoStored,
                    showChevron: false,
                  ),
                  SettingsRow(
                    label: lo.documentSize,
                    trailingText: formatBytes(info.documentBytes),
                    showChevron: false,
                  ),
                  SettingsRow(
                    label: lo.cloudCopy,
                    trailingText: info.isPhotoUploaded
                        ? lo.cloudCopyUploaded
                        : lo.cloudCopyPending,
                    showChevron: false,
                    showBottomDivider: false,
                  ),
                ],
              ),
            ),
            Text(
              lo.storageDetailsNote,
              style: textTheme.footnote13.copyWith(color: scheme.ter),
            ),
          ],
        ),
      ),
    );
  }
}

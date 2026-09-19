import 'package:flutter/material.dart';

import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/widgets/labeled_field.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../../core/widgets/sheet_close_header.dart';
import '../../../bloc/edit_store_bloc/edit_store_bloc.dart';
import '../../new_store_page/widgets/new_store_text_field.dart';
import 'editable_store_logo.dart';
import 'save_store_button.dart';

/// The Edit Store form: logo, name, Save.
///
/// KEYBOARD-HIDES-FIELD GUARD (`db:keyboard-hides-text-field`): the whole form
/// sits inside one [SingleChildScrollView] and the Save button is INSIDE that
/// same scroll region rather than pinned below it, so both the field and the
/// button stay reachable once the keyboard opens. The page's `Scaffold` keeps
/// its default `resizeToAvoidBottomInset: true`, which shrinks the viewport —
/// no manual `viewInsets` padding is needed here.
class EditStorePageBody extends StatelessWidget {
  final EditStoreState state;
  final TextEditingController nameController;
  final VoidCallback onLogoTap;
  final VoidCallback onSave;
  final VoidCallback onClose;

  const EditStorePageBody({
    super.key,
    required this.state,
    required this.nameController,
    required this.onLogoTap,
    required this.onSave,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final lo = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20.0,
          children: [
            SheetCloseHeader(title: lo.editStore, onClose: onClose),
            Center(
              child: EditableStoreLogo(
                filename: state.logoFilename,
                storeName: state.name,
                onTap: onLogoTap,
                isUploading: state.isLogoBusy,
              ),
            ),
            LabeledField(
              label: lo.name,
              child: NewStoreTextField(
                controller: nameController,
                hintText: lo.namePh,
                textInputAction: TextInputAction.done,
              ),
            ),
            SaveStoreButton(
              isSaving: state.isSaving,
              isPickingLogo: state.isPickingLogo,
              isUploadingLogo: state.isUploadingLogo,
              canSave: state.canSave,
              onSave: onSave,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../../core/resources/text/app_text_theme.dart';
import '../../../../../../core/widgets/app_container.dart';
import '../../../../../../core/widgets/labeled_field.dart';
import '../../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'edit_profile_header_row.dart';
import 'edit_profile_text_field.dart';
import 'editable_avatar.dart';
import 'save_profile_button.dart';

/// The Edit Profile form: avatar, first/last name, read-only email, Save.
class EditProfileBody extends StatelessWidget {
  final EditProfileState state;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final VoidCallback onAvatarTap;
  final VoidCallback onSave;

  const EditProfileBody({
    super.key,
    required this.state,
    required this.firstNameController,
    required this.lastNameController,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onAvatarTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final lo = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: HorizontalPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20.0,
          children: [
            const EditProfileHeaderRow(),
            Center(
              child: EditableAvatar(
                filename: state.avatarFilename,
                onTap: onAvatarTap,
                isUploading: state.isAvatarBusy,
              ),
            ),
            LabeledField(
              label: lo.firstName,
              child: EditProfileTextField(
                controller: firstNameController,
                hintText: lo.nameHint,
                onChanged: onFirstNameChanged,
              ),
            ),
            LabeledField(
              label: lo.lastName,
              child: EditProfileTextField(
                controller: lastNameController,
                hintText: lo.nameHint,
                onChanged: onLastNameChanged,
                textInputAction: TextInputAction.done,
              ),
            ),
            // Read-only: the email is the identity the provider authenticated,
            // not a user preference. Rendered as a static filled row rather
            // than a disabled input so it never looks tappable.
            //
            // `width: double.infinity` is load-bearing: `LabeledField`'s Column
            // aligns children to `start` and does not stretch them, so the
            // container shrink-wrapped its Text and an empty email collapsed it
            // into a small orphaned pill — visibly broken next to the two
            // full-width name fields above it.
            LabeledField(
              label: lo.emailLabel,
              child: AppContainer(
                width: double.infinity,
                color: scheme.fieldDim,
                borderRadius: BorderRadius.circular(14.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                child: Text(
                  // An address can exceed the row on a narrow screen; wrapping
                  // keeps it readable rather than clipping the domain, which is
                  // the half that identifies the account.
                  state.email,
                  style: textTheme.body17.copyWith(color: scheme.sec),
                ),
              ),
            ),
            SaveProfileButton(
              isSaving: state.isSaving,
              isPickingPhoto: state.isPickingPhoto,
              isUploadingPhoto: state.isUploadingPhoto,
              canSave: state.canSave,
              onSave: onSave,
            ),
          ],
        ),
      ),
    );
  }
}

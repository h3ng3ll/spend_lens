import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/services/permission_requester.dart';
import '../../../../../core/services/receipt_image_store/receipt_image_store.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../domain/repositories/i_receipt_local_repository.dart';
import '../../bloc/receipt_photo_bloc/receipt_photo_bloc.dart';
import 'widgets/receipt_photo_body.dart';

/// `ReceiptPhotoPageRoute` (design_spendlens.md §5) — a top-level push above
/// the shell showing a saved receipt's photo full-screen.
///
/// Implements the designed "Choose from library" action (`lo.chooseLibrary`),
/// which had been localized in all 7 locales with no consumer while this
/// screen was an app-bar-only placeholder — leaving no way for the user to
/// supply a receipt image manually. `retake`/`view`/`share` remain
/// unimplemented and are deliberately NOT added here.
///
/// [ReceiptPhotoBloc] is screen-scoped (built here, closed in `dispose` —
/// BLoC rule A3.8) and reads REACTIVELY: the photo can be replaced or the
/// receipt deleted from another surface while this screen is open.
class ReceiptPhotoPage extends StatefulWidget {
  final String receiptId;

  const ReceiptPhotoPage({super.key, required this.receiptId});

  @override
  State<ReceiptPhotoPage> createState() => _ReceiptPhotoPageState();
}

class _ReceiptPhotoPageState extends State<ReceiptPhotoPage> {
  late final ReceiptPhotoBloc _bloc = ReceiptPhotoBloc(
    receiptRepository: getIt<IReceiptLocalRepository>(),
    imageStore: getIt<ReceiptImageStore>(),
  )..add(ReceiptPhotoEvent.load(widget.receiptId));

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  /// Gallery only — this action is "Choose from library". Camera capture is
  /// the scanner's job, and `retake` is not part of this change.
  Future<void> _onChooseLibrary() async {
    final File? file = await getIt<PermissionRequester>().onPickGallery(
      context,
    );
    if (file == null) return;

    _bloc.add(ReceiptPhotoEvent.replaceFromFile(file));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: scheme.bg,
        appBar: CustomAppBar(title: Text(lo.receiptPhoto)),
        body: ReceiptPhotoBody(onChooseLibrary: _onChooseLibrary),
      ),
    );
  }
}

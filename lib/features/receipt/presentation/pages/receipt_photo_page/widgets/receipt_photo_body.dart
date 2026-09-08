import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/receipt_photo_bloc/receipt_photo_bloc.dart';
import 'receipt_photo_empty.dart';
import 'receipt_photo_view.dart';

/// Picks between the receipt-photo states: probe in flight, no photo (with
/// the designed "Choose from library" action), or the stored image.
///
/// A failed load resolves to the SAME empty state as "no photo": from the
/// user's side both mean "there is nothing to show and here is how to add
/// something", and an error message they cannot act on would be strictly
/// worse than an actionable one.
class ReceiptPhotoBody extends StatelessWidget {
  final Future<void> Function() onChooseLibrary;

  const ReceiptPhotoBody({super.key, required this.onChooseLibrary});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptPhotoBloc, ReceiptPhotoState>(
      builder: (context, state) {
        if (state.isLoading || state.status == EReceiptPhotoStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.hasNoPhoto || state.isFailed) {
          return ReceiptPhotoEmpty(onChooseLibrary: onChooseLibrary);
        }

        return ReceiptPhotoView(
          filename: state.imagePath!,
          onChooseLibrary: onChooseLibrary,
        );
      },
    );
  }
}

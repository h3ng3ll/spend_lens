import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/resources/localization/gen/app_localizations.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../domain/repositories/i_receipt_repository.dart';
import '../../bloc/receipt_storage_bloc/receipt_storage_bloc.dart';
import 'widgets/receipt_storage_body.dart';

/// `ReceiptStoragePageRoute` — what one receipt costs in storage, reached
/// from Record Detail's header menu.
///
/// Exists because the account-wide figure on Profile answers "how full am
/// I" but never "what is filling it": with no per-receipt attribution, a
/// user near their quota had nothing to act on.
///
/// [ReceiptStorageBloc] is screen-scoped (built here in `initState`, closed
/// in `dispose` — BLoC rule A3.8).
class ReceiptStoragePage extends StatefulWidget {
  final String receiptId;

  const ReceiptStoragePage({super.key, required this.receiptId});

  @override
  State<ReceiptStoragePage> createState() => _ReceiptStoragePageState();
}

class _ReceiptStoragePageState extends State<ReceiptStoragePage> {
  late final ReceiptStorageBloc _bloc = ReceiptStorageBloc(
    receiptId: widget.receiptId,
    receiptRepository: getIt<IReceiptRepository>(),
  )..add(const ReceiptStorageEvent.load());

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);
    final lo = AppLocalizations.of(context);

    return BlocProvider<ReceiptStorageBloc>.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: scheme.bg,
        appBar: CustomAppBar(title: Text(lo.storageDetails)),
        body: SafeArea(
          child: BlocBuilder<ReceiptStorageBloc, ReceiptStorageState>(
            builder: (context, state) => ReceiptStorageBody(state: state),
          ),
        ),
      ),
    );
  }
}

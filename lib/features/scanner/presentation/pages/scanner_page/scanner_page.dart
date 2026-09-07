import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_color_scheme.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../bloc/scanner_bloc/scanner_bloc.dart';
import 'widgets/scanner_body.dart';

/// `ScannerPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell. The scanner's four sub-states (searching/detected/capturing/
/// processing/failed) are ONE route, driven by [ScannerBloc].
///
/// [ScannerBloc] is screen-scoped (`registerFactory` semantics): built here
/// in `initState`, closed in `dispose` — never registered in `main()`
/// (BLoC rule A3.8).
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final ScannerBloc _scannerBloc = ScannerBloc();

  @override
  void dispose() {
    _scannerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: scheme.bg,
      appBar: const CustomAppBar(),
      body: BlocProvider<ScannerBloc>.value(
        value: _scannerBloc,
        child: BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) => ScannerBody(state: state),
        ),
      ),
    );
  }
}

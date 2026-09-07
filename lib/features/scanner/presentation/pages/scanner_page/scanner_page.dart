import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/colors/app_colors.dart';
import '../../bloc/scanner_bloc/scanner_bloc.dart';
import 'widgets/scanner_body.dart';

/// `ScannerPageRoute` (design_spendlens.md §5) — a top-level push above the
/// shell. The scanner's four sub-states (searching/detected/capturing/
/// processing/failed) are ONE route, driven by [ScannerBloc].
///
/// Full-bleed camera preview — NO `CustomAppBar` (the design's Scanner
/// artboard has no title bar; its close/flash controls float over the
/// preview as translucent pills). Because this screen owns its own insets
/// entirely (top-level push, not a shell branch —
/// `missing-safearea-top-inset-header-behind-statusbar` /
/// `control-rendered-inside-the-system-cutout-inset-is-untappable`), every
/// overlay control positions itself with `MediaQuery.paddingOf(context)`
/// rather than assuming a shared `SafeArea`.
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
    return Scaffold(
      backgroundColor: AppColors.black.value,
      body: BlocProvider<ScannerBloc>.value(
        value: _scannerBloc,
        child: const ScannerBody(),
      ),
    );
  }
}

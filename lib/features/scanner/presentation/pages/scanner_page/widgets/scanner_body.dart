import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../presentation/bloc/scanner_bloc/scanner_bloc.dart';
import 'camera_preview_layer.dart';
import 'scanner_processing_sheet.dart';
import 'scanner_top_controls.dart';

/// The scanner's four sub-states as one body (design_spendlens.md §5):
/// [CameraPreviewLayer] owns the camera + pipeline orchestration and paints
/// the searching/detected/capturing overlays; [ScannerProcessingSheet]
/// slides up only while `EScannerStatus.processing`.
///
/// Reads [SettingsBloc] via an explicit `BlocBuilder` (never a raw
/// `context.watch`/`.read` inside `build()`, per BLoC rule A3.6) for the
/// persisted flash preference — flash is a device-level setting owned by
/// the app-lifetime `SettingsBloc`, not scanner-screen state.
class ScannerBody extends StatelessWidget {
  const ScannerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.settings.flashMode != current.settings.flashMode,
      builder: (context, settingsState) {
        return BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreviewLayer(
                  state: state,
                  flashMode: settingsState.settings.flashMode,
                ),
                ScannerTopControls(
                  flashMode: settingsState.settings.flashMode,
                ),
                if (state.isProcessing)
                  ScannerProcessingSheet(processingStep: state.processingStep),
              ],
            );
          },
        );
      },
    );
  }
}

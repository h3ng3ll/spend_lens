import 'dart:async';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../ocr/ocr_service.dart';
import 'e_scan_capability.dart';
import 'i_scan_capability_service.dart';

/// How long the native camera-enumeration probe (`availableCameras()`) may
/// run before this service gives up on it and reports
/// [EScanCapability.unavailable]. Bound for the same reason
/// `Apphud.start` is timeout-bound (`sig:unbounded-third-party-sdk-await-
/// before-runapp-hangs-first-frame`): a plugin channel call is a native
/// await this Dart code cannot otherwise cap, and an unbounded await on it
/// can hang the calling UI (Home's "Scan Receipt" / Settings' capability
/// row) with no exception and no log.
const Duration _kHardwareProbeTimeout = Duration(seconds: 5);

/// The single, real [IScanCapabilityService] implementation.
///
/// Order of checks matters and is deliberate: permission is resolved
/// FIRST, because `availableCameras()` can throw or return an empty list on
/// some Android OEM skins when permission has never been granted, which
/// would otherwise be misreported as [EScanCapability.noCamera] rather than
/// the real [EScanCapability.permissionDenied] cause.
///
/// This class never branches on `Platform.isX` (design_spendlens.md §6) —
/// every signal it reads (`permission_handler`'s status, `camera`'s device
/// enumeration, [OcrService.isAvailable]) is itself platform-agnostic at the
/// call site; the platform difference lives entirely in those packages'
/// own native implementations.
class ScanCapabilityService implements IScanCapabilityService {
  final OcrService _ocrService;

  const ScanCapabilityService(this._ocrService);

  @override
  Future<EScanCapability> check() async {
    final status = await ph.Permission.camera.status;

    if (status.isPermanentlyDenied) {
      return EScanCapability.permissionPermanentlyDenied;
    }
    if (status.isDenied || status.isRestricted) {
      return EScanCapability.permissionDenied;
    }

    return _checkHardwareAndOcr();
  }

  @override
  Future<EScanCapability> requestPermission() async {
    final status = await ph.Permission.camera.request();

    if (status.isPermanentlyDenied) {
      return EScanCapability.permissionPermanentlyDenied;
    }
    if (status.isDenied || status.isRestricted) {
      return EScanCapability.permissionDenied;
    }

    return _checkHardwareAndOcr();
  }

  @override
  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  Future<EScanCapability> _checkHardwareAndOcr() async {
    final bool? hasCamera = await _hasUsableCameraOrTimeout();
    if (hasCamera == null) return EScanCapability.unavailable;
    if (!hasCamera) return EScanCapability.noCamera;

    final ocrAvailable = await _ocrService.isAvailable();
    if (!ocrAvailable) return EScanCapability.ocrUnavailable;

    return EScanCapability.supported;
  }

  /// `null` means the probe did not settle within [_kHardwareProbeTimeout] —
  /// distinct from `false` ("settled, no camera"), so the caller can report
  /// [EScanCapability.unavailable] instead of misreporting [noCamera].
  Future<bool?> _hasUsableCameraOrTimeout() async {
    try {
      final cameras = await availableCameras().timeout(
        _kHardwareProbeTimeout,
      );
      return cameras.isNotEmpty;
    } on CameraException {
      return false;
    } on TimeoutException {
      return null;
    }
  }
}

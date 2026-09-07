import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../ocr/ocr_service.dart';
import 'e_scan_capability.dart';
import 'i_scan_capability_service.dart';

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
    final hasCamera = await _hasUsableCamera();
    if (!hasCamera) return EScanCapability.noCamera;

    final ocrAvailable = await _ocrService.isAvailable();
    if (!ocrAvailable) return EScanCapability.ocrUnavailable;

    return EScanCapability.supported;
  }

  Future<bool> _hasUsableCamera() async {
    try {
      final cameras = await availableCameras();
      return cameras.isNotEmpty;
    } on CameraException {
      return false;
    }
  }
}

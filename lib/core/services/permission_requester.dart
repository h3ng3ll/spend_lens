import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../resources/localization/gen/app_localizations.dart';
import 'scan_capability/e_scan_capability.dart';
import 'scan_capability/i_scan_capability_service.dart';
import 'ui_message_service.dart';

/// Picks an image for the user, from the gallery or the camera.
///
/// MUST stay a singleton: [isPicking] is a process-wide re-entrancy guard that
/// only works while every caller shares one instance. Registering this as a
/// factory would hand each call site a fresh `isPicking == false` and silently
/// delete the double-pick protection.
///
/// Camera permission is NOT decided here — [onPickCamera] delegates to
/// [IScanCapabilityService], which is the app's single camera-capability
/// authority. Two surfaces deriving capability independently is exactly what
/// that interface's contract forbids, and it is how the two can end up
/// disagreeing about whether the camera works.
class PermissionRequester {
  final IScanCapabilityService _scanCapabilityService;

  bool isPicking = false;

  PermissionRequester(this._scanCapabilityService);

  /// Gallery reads need no runtime permission on either platform: both
  /// `image_picker` backends hand off to an OS-owned picker UI (iOS
  /// `PHPicker`, Android `ACTION_OPEN_DOCUMENT` / Photo Picker) that returns
  /// only the item the user chose. Requesting one here would surface a
  /// prompt the user can only refuse, for access the app never needs.
  Future<File?> onPickGallery(BuildContext context) async {
    if (isPicking) return null;
    isPicking = true;

    // Resolved BEFORE the await: reading localizations off `context` after a
    // suspension point is unsafe if the element unmounts while the OS picker
    // is in front of the app.
    final lo = AppLocalizations.of(context);

    try {
      final res = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (res == null) return null;
      return File(res.path);
    } catch (_) {
      UiMessageService.showError(lo.pickImageFailed);
      return null;
    } finally {
      isPicking = false;
    }
  }

  Future<File?> onPickCamera(BuildContext context) async {
    if (isPicking) return null;
    isPicking = true;

    // Resolved BEFORE the awaits — see [onPickGallery].
    final lo = AppLocalizations.of(context);

    try {
      final capability = await _scanCapabilityService.checkOrRequest();

      // `ocrUnavailable` is explicitly ALLOWED through: it means a camera
      // exists and permission is granted, but on-device text recognition is
      // not available. Taking a photo does not need OCR — only SCANNING
      // does — so blocking a plain capture on it would refuse a gesture
      // that works perfectly well.
      final canCapture =
          capability == EScanCapability.supported ||
          capability == EScanCapability.ocrUnavailable;

      if (!canCapture) {
        await UiMessageService.showInfo(
          switch (capability) {
            EScanCapability.noCamera => lo.scanUnsupportedNoCamera,
            EScanCapability.permissionDenied =>
              lo.scanUnsupportedPermissionDenied,
            EScanCapability.permissionPermanentlyDenied =>
              lo.scanUnsupportedPermissionPermanentlyDenied,
            EScanCapability.unavailable ||
            EScanCapability.ocrUnavailable ||
            EScanCapability.supported => lo.scanUnsupportedUnavailable,
          },
        );
        return null;
      }

      final res = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (res == null) return null;
      return File(res.path);
    } catch (_) {
      UiMessageService.showError(lo.pickImageFailed);
      return null;
    } finally {
      isPicking = false;
    }
  }
}

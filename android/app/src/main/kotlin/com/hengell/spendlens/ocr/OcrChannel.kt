package com.hengell.spendlens.ocr

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * The Android half of `com.hengell.spendlens/ocr` — the single channel
 * contract shared with iOS (see `IScanCapabilityService` /
 * `core/services/ocr/ocr_service.dart` on the Dart side; both platforms
 * expose the SAME four method names so Dart never branches above the
 * service boundary — design_spendlens.md §6).
 *
 * M7 implements `isAvailable` for real: `google_mlkit_text_recognition`'s
 * Latin recognizer is bundled into the APK via the
 * `com.google.mlkit.vision.DEPENDENCIES` manifest metadata (never a
 * downloaded model — design_spendlens.md §64), so on-device OCR is always
 * available once the device has the Play Services ML Kit runtime, which
 * `isAvailable` reports. `recognizeText`, `detectReceiptRect` and
 * `cropPerspective` are declared here with their exact method names now so
 * M8 only fills in bodies (`google_mlkit_text_recognition` for OCR, Kotlin +
 * OpenCV/Android's own APIs for headless rect detection and perspective
 * crop) — never a new method name introduced later.
 */
class OcrChannel : FlutterPlugin, MethodCallHandler {
  private var channel: MethodChannel? = null

  companion object {
    const val CHANNEL_NAME = "com.hengell.spendlens/ocr"
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME)
    channel?.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
    channel = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "isAvailable" -> {
        // The Latin recognizer model is bundled at install time (see the
        // manifest's `com.google.mlkit.vision.DEPENDENCIES` metadata), so
        // this reports true unconditionally on Android — hardware/
        // permission gating is `IScanCapabilityService`'s job, not this
        // channel's.
        result.success(true)
      }

      "recognizeText" -> {
        // M8: google_mlkit_text_recognition's TextRecognizer with the
        // Latin script options. Bounding boxes are REQUIRED in the result
        // (design_spendlens.md §6 — never collapse to a single String).
        result.error("UNIMPLEMENTED", "recognizeText lands in M8", null)
      }

      "detectReceiptRect" -> {
        // M8: headless rectangle detection (Kotlin-only path — no OCR
        // model needed for this stage). Detection failure never blocks OCR
        // (design_spendlens.md §24) — null is a valid outcome the Dart side
        // already treats as "proceed on the original image".
        result.success(null)
      }

      "cropPerspective" -> {
        // M8: perspective-correct crop using the rect from
        // detectReceiptRect.
        result.error("UNIMPLEMENTED", "cropPerspective lands in M8", null)
      }

      else -> result.notImplemented()
    }
  }
}

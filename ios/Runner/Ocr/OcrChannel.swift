import Flutter
import Foundation
import Vision

/// The iOS half of `com.hengell.spendlens/ocr` — the single channel contract
/// shared with Android (see `IScanCapabilityService` /
/// `core/services/ocr/ocr_service.dart` on the Dart side; both platforms
/// expose the SAME four method names so Dart never branches above the
/// service boundary — design_spendlens.md §6).
///
/// M7 implements `isAvailable` for real (iOS 13+ ships `Vision` on every
/// device, so this always resolves `true` on a real iOS build/simulator that
/// has the framework — capability is a hardware/permission question handled
/// by `IScanCapabilityService`, not by this channel). `recognizeText`,
/// `detectReceiptRect` and `cropPerspective` are declared here with their
/// exact method names now so M8 only fills in bodies with
/// `VNRecognizeTextRequest` (`recognitionLanguages: ["ro-RO", "en-US"]`,
/// `.accurate`, language correction on) and
/// `VNDetectRectanglesRequest` + `CIPerspectiveCorrection` — never a new
/// method name introduced later.
final class OcrChannel: NSObject {
  static let channelName = "com.hengell.spendlens/ocr"

  static func register(with registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "OcrChannel") else { return }
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      handle(call, result: result)
    }
  }

  private static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      // Vision's VNRecognizeTextRequest ships on iOS 13+, so real OCR is
      // always available on-device here — never a downloaded model, so
      // there is no airplane-mode-first-launch failure mode to guard
      // against on this platform (design_spendlens.md §64/§6).
      result(true)

    case "recognizeText":
      // M8: VNRecognizeTextRequest(recognitionLanguages: ["ro-RO", "en-US"],
      // .accurate, usesLanguageCorrection: true). Bounding boxes are
      // REQUIRED in the result (design_spendlens.md §6 — never collapse to
      // a single String).
      result(
        FlutterError(
          code: "UNIMPLEMENTED",
          message: "recognizeText lands in M8",
          details: nil
        )
      )

    case "detectReceiptRect":
      // M8: VNDetectRectanglesRequest. Detection failure never blocks OCR
      // (design_spendlens.md §24) — a null result here is a valid outcome
      // the Dart side already treats as "proceed on the original image".
      result(nil)

    case "cropPerspective":
      // M8: CIPerspectiveCorrection using the rect from detectReceiptRect.
      result(
        FlutterError(
          code: "UNIMPLEMENTED",
          message: "cropPerspective lands in M8",
          details: nil
        )
      )

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

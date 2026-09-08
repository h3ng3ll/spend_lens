import Flutter
import Foundation
import UIKit
import Vision
import CoreImage

/// The iOS half of `com.hengell.spendlens/ocr` — the single channel contract
/// shared with Android (see `IScanCapabilityService` /
/// `core/services/ocr/ocr_service.dart` on the Dart side; both platforms
/// expose the SAME four method names so Dart never branches above the
/// service boundary — design_spendlens.md §6).
///
/// `recognizeText` uses `VNRecognizeTextRequest` with
/// `recognitionLanguages: ["ro-RO", "en-US"]`, `.accurate`, and language
/// correction ON (design_spendlens.md §6/§10). Bounding boxes are REQUIRED
/// in the result — never a single collapsed `String` (§27).
///
/// `detectReceiptRect`/`cropPerspective` use `VNDetectRectanglesRequest` +
/// `CIPerspectiveCorrection`. Per §24, a failed/uncertain detection returns
/// `nil` rather than a guess — the Dart side already treats that as
/// "proceed on the original image".
final class OcrChannel: NSObject {
  static let channelName = "com.hengell.spendlens/ocr"

  /// Vision's rectangle detector runs a confidence-scored search; only a
  /// result at or above this confidence is trusted as a genuine receipt
  /// edge — below it, `nil` is returned rather than a guessed rect (a
  /// logic literal per A7, not a UI value).
  private static let minimumRectangleConfidence: VNConfidence = 0.6

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
      guard
        let args = call.arguments as? [String: Any],
        let imageBytes = args["imageBytes"] as? FlutterStandardTypedData,
        let decoded = decode(imageBytes.data)
      else {
        result([])
        return
      }
      recognizeText(
        cgImage: decoded.image,
        orientation: decoded.orientation,
        result: result
      )

    case "detectReceiptRect":
      guard
        let args = call.arguments as? [String: Any],
        let imageBytes = args["imageBytes"] as? FlutterStandardTypedData,
        let decoded = decode(imageBytes.data)
      else {
        // design_spendlens.md §24: detection failure never blocks OCR — a
        // decode failure here is the same legitimate "not found" outcome
        // as no rectangle being detected.
        result(nil)
        return
      }
      detectReceiptRect(
        cgImage: decoded.image,
        orientation: decoded.orientation,
        result: result
      )

    case "cropPerspective":
      let args = call.arguments as? [String: Any]
      let imageBytes = args?["imageBytes"] as? FlutterStandardTypedData
      guard
        let imageBytes = imageBytes,
        let left = (args?["left"] as? NSNumber)?.doubleValue,
        let top = (args?["top"] as? NSNumber)?.doubleValue,
        let width = (args?["width"] as? NSNumber)?.doubleValue,
        let height = (args?["height"] as? NSNumber)?.doubleValue
      else {
        // The original bytes are the safest fallback when the arguments
        // are malformed — never a thrown error for a shape mismatch the
        // Dart side already guards against on its own end.
        result(imageBytes)
        return
      }
      cropPerspective(
        imageBytes: imageBytes.data,
        rect: CGRect(x: left, y: top, width: width, height: height),
        result: result
      )

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - recognizeText

  private static func recognizeText(
    cgImage: CGImage,
    orientation: CGImagePropertyOrientation,
    result: @escaping FlutterResult
  ) {
    let request = VNRecognizeTextRequest { request, error in
      guard error == nil,
        let observations = request.results as? [VNRecognizedTextObservation]
      else {
        result([])
        return
      }

      let (imageWidth, imageHeight) = orientedSize(
        of: cgImage,
        orientation: orientation
      )

      let blocks: [[String: Any]] = observations.compactMap { observation in
        guard let candidate = observation.topCandidates(1).first else { return nil }

        // Vision reports bounding boxes in NORMALIZED coordinates with the
        // origin at the BOTTOM-LEFT — convert to the same top-left, pixel
        // coordinate space the Android side and the parser's line grouper
        // expect (design_spendlens.md §6 — bounding boxes are required,
        // and must be consistent across platforms).
        let box = observation.boundingBox
        let left = box.minX * imageWidth
        let width = box.width * imageWidth
        let height = box.height * imageHeight
        let top = (1.0 - box.maxY) * imageHeight

        return [
          "text": candidate.string,
          "left": left,
          "top": top,
          "width": width,
          "height": height,
          "confidence": Double(candidate.confidence),
        ]
      }

      result(blocks)
    }

    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["ro-RO", "en-US"]
    request.usesLanguageCorrection = true

    perform(request, on: cgImage, orientation: orientation) { result([]) }
  }

  // MARK: - detectReceiptRect

  private static func detectReceiptRect(
    cgImage: CGImage,
    orientation: CGImagePropertyOrientation,
    result: @escaping FlutterResult
  ) {
    let request = VNDetectRectanglesRequest { request, error in
      guard error == nil,
        let observations = request.results as? [VNRectangleObservation],
        let best = observations
          .filter({ $0.confidence >= minimumRectangleConfidence })
          .max(by: { $0.confidence < $1.confidence })
      else {
        // §24 — no confident rectangle found is a legitimate outcome.
        result(nil)
        return
      }

      let (imageWidth, imageHeight) = orientedSize(
        of: cgImage,
        orientation: orientation
      )
      let box = best.boundingBox
      let left = box.minX * imageWidth
      let width = box.width * imageWidth
      let height = box.height * imageHeight
      let top = (1.0 - box.maxY) * imageHeight

      result([
        "left": left,
        "top": top,
        "width": width,
        "height": height,
      ])
    }

    // A receipt is a tall, roughly-rectangular document — bias the search
    // toward that shape without hard-rejecting a receipt held slightly
    // askew.
    request.minimumAspectRatio = 0.2
    request.maximumAspectRatio = 1.0
    request.minimumSize = 0.2
    request.maximumObservations = 1

    perform(request, on: cgImage, orientation: orientation) { result(nil) }
  }

  // MARK: - cropPerspective

  private static func cropPerspective(
    imageBytes: Data,
    rect: CGRect,
    result: @escaping FlutterResult
  ) {
    let orientation = UIImage(data: imageBytes)
      .map { cgOrientation(from: $0.imageOrientation) } ?? .up

    // `.oriented()` bakes the EXIF orientation into the image's own extent,
    // so this crop works in the SAME oriented coordinate space that
    // `detectReceiptRect` now reports its rect in. Without it, `CIImage`
    // (which ignores EXIF exactly as `CGImage` and `BitmapFactory` do) would
    // be cropped with a rect measured against a differently-rotated image —
    // slicing the wrong band out of the receipt.
    guard let ciImage = CIImage(data: imageBytes)?.oriented(orientation) else {
      result(imageBytes)
      return
    }

    // `CIPerspectiveCorrection` takes the four CORNERS of the detected
    // quad, in Core Image's bottom-left-origin coordinate space. Since
    // `detectReceiptRect` returns a top-left-origin AXIS-ALIGNED rect (to
    // stay consistent with the Android side), the four corners here are
    // that rect's own corners converted to Core Image's coordinate space
    // — a faithful perspective correction of a genuinely skewed quad would
    // need the raw `VNRectangleObservation` corners, which is a refinement
    // left for real-photo tuning (see this file's class doc / M8 handoff
    // notes on re-tunability); this still performs a real, non-simulated
    // crop using the detected bounds.
    let imageHeight = ciImage.extent.height
    let left = rect.minX
    let top = imageHeight - rect.maxY
    let width = rect.width
    let height = rect.height

    let topLeft = CGPoint(x: left, y: top + height)
    let topRight = CGPoint(x: left + width, y: top + height)
    let bottomLeft = CGPoint(x: left, y: top)
    let bottomRight = CGPoint(x: left + width, y: top)

    guard let filter = CIFilter(name: "CIPerspectiveCorrection") else {
      result(imageBytes)
      return
    }
    filter.setValue(ciImage, forKey: kCIInputImageKey)
    filter.setValue(CIVector(cgPoint: topLeft), forKey: "inputTopLeft")
    filter.setValue(CIVector(cgPoint: topRight), forKey: "inputTopRight")
    filter.setValue(CIVector(cgPoint: bottomLeft), forKey: "inputBottomLeft")
    filter.setValue(CIVector(cgPoint: bottomRight), forKey: "inputBottomRight")

    guard let outputImage = filter.outputImage else {
      result(imageBytes)
      return
    }

    let context = CIContext()
    guard
      let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
    else {
      result(imageBytes)
      return
    }

    let uiImage = UIImage(cgImage: cgImage)
    guard let jpegData = uiImage.jpegData(compressionQuality: 0.92) else {
      result(imageBytes)
      return
    }

    result(FlutterStandardTypedData(bytes: jpegData))
  }

  // MARK: - Helpers

  /// The pixel size of the image AS VISION SEES IT once `orientation` is
  /// applied.
  ///
  /// A `.left`/`.right` (90°) orientation swaps width and height, and Vision
  /// normalizes its bounding boxes against that ORIENTED extent — so
  /// denormalizing with the raw `cgImage.width`/`.height` would stretch every
  /// box along the wrong axis on exactly the portrait captures this channel
  /// receives, scrambling the line grouper's row/column geometry.
  private static func orientedSize(
    of cgImage: CGImage,
    orientation: CGImagePropertyOrientation
  ) -> (width: CGFloat, height: CGFloat) {
    let width = CGFloat(cgImage.width)
    let height = CGFloat(cgImage.height)
    switch orientation {
    case .left, .leftMirrored, .right, .rightMirrored:
      return (height, width)
    default:
      return (width, height)
    }
  }

  /// Decodes JPEG bytes into a `CGImage` PLUS the EXIF orientation that
  /// describes how those raw pixels must be rotated to appear upright.
  ///
  /// `UIImage(data:)` parses the EXIF `Orientation` tag into
  /// `imageOrientation`, but `.cgImage` hands back the RAW, unrotated pixel
  /// buffer and drops it. `camera`'s `takePicture()` writes a JPEG whose
  /// orientation lives ONLY in that tag — the pixels are never rewritten —
  /// so reading `.cgImage` alone fed Vision a sideways receipt, and
  /// `VNRecognizeTextRequest` does not read 90°-rotated lines. This is the
  /// same defect fixed on Android in `OcrChannel.decodeBitmap`, which
  /// rotates the bitmap because `BitmapFactory` ignores EXIF too.
  ///
  /// Vision is told the orientation instead of the pixels being rotated:
  /// `VNImageRequestHandler` applies it internally and, critically, reports
  /// bounding boxes in the ORIENTED coordinate space — so the normalized
  /// boxes below stay correct without any extra transform, and no full
  /// second copy of a multi-megapixel image is allocated (this capture path
  /// already hit a 2 GB OOM once).
  private static func decode(
    _ data: Data
  ) -> (image: CGImage, orientation: CGImagePropertyOrientation)? {
    guard let uiImage = UIImage(data: data), let cgImage = uiImage.cgImage else {
      return nil
    }
    return (cgImage, cgOrientation(from: uiImage.imageOrientation))
  }

  private static func cgOrientation(
    from orientation: UIImage.Orientation
  ) -> CGImagePropertyOrientation {
    switch orientation {
    case .up: return .up
    case .down: return .down
    case .left: return .left
    case .right: return .right
    case .upMirrored: return .upMirrored
    case .downMirrored: return .downMirrored
    case .leftMirrored: return .leftMirrored
    case .rightMirrored: return .rightMirrored
    @unknown default: return .up
    }
  }

  /// Runs a Vision request OFF the platform thread.
  ///
  /// `VNImageRequestHandler.perform` is SYNCHRONOUS and invokes the
  /// request's completion block on the calling thread. Called straight from
  /// the channel handler, that thread is the platform thread — so an
  /// `.accurate` recognition pass over a full-resolution receipt blocked the
  /// very thread that had to deliver the reply, and the Dart side hit its
  /// 10s timeout and reported "no text blocks" every time. This is the iOS
  /// twin of the Android `CountDownLatch` deadlock: the thread that must
  /// carry the result was the one being held.
  ///
  /// `FlutterResult` is safe to invoke from a background queue — the engine
  /// hops the reply to the platform thread itself.
  private static func perform(
    _ request: VNImageBasedRequest,
    on cgImage: CGImage,
    orientation: CGImagePropertyOrientation,
    onFailure: @escaping () -> Void
  ) {
    DispatchQueue.global(qos: .userInitiated).async {
      let handler = VNImageRequestHandler(
        cgImage: cgImage,
        orientation: orientation,
        options: [:]
      )
      do {
        try handler.perform([request])
      } catch {
        onFailure()
      }
    }
  }
}

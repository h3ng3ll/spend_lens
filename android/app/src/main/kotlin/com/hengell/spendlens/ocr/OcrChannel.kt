package com.hengell.spendlens.ocr

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.Matrix
import android.graphics.Rect
import android.util.Log
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min

/**
 * The Android half of `com.hengell.spendlens/ocr` — the single channel
 * contract shared with iOS (see `IScanCapabilityService` /
 * `core/services/ocr/ocr_service.dart` on the Dart side; both platforms
 * expose the SAME four method names so Dart never branches above the
 * service boundary — design_spendlens.md §6).
 *
 * `recognizeText` uses ML Kit's Latin [TextRecognition] SDK — the SAME
 * native `com.google.mlkit:text-recognition` artifact the
 * `google_mlkit_text_recognition` Flutter plugin wraps (it is pulled in
 * transitively as a Gradle dependency of that pub package; see
 * `android/app/build.gradle.kts`), invoked here directly from Kotlin. This
 * is what design_spendlens.md §6 means by "no Kotlin needed for OCR" — no
 * custom recognition algorithm is written here, only a call into the
 * already-bundled ML Kit model — while the channel itself stays identical
 * to iOS.
 *
 * `detectReceiptRect`/`cropPerspective` ARE Kotlin-authored: a lightweight
 * luminance-gradient border scan (no OpenCV dependency) that looks for the
 * photographed receipt's bright paper against a darker background. Per
 * design_spendlens.md §24, a failed/uncertain detection returns `null`
 * rather than a guess — the Dart side already treats that as "proceed on
 * the original image", never as an error.
 */
class OcrChannel : FlutterPlugin, MethodCallHandler {
  private var channel: MethodChannel? = null

  companion object {
    const val CHANNEL_NAME = "com.hengell.spendlens/ocr"
    private const val TAG = "OcrChannel"

    /** Border-scan tuning — a logic constant, not a UI literal (A7). */
    private const val EDGE_LUMINANCE_DELTA_THRESHOLD = 40
    private const val EDGE_SCAN_STEP_FRACTION = 0.01
    private const val MIN_RECEIPT_AREA_FRACTION = 0.15
  }

  private val recognizer =
    TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)

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

      "recognizeText" -> handleRecognizeText(call, result)

      "detectReceiptRect" -> handleDetectReceiptRect(call, result)

      "cropPerspective" -> handleCropPerspective(call, result)

      else -> result.notImplemented()
    }
  }

  private fun handleRecognizeText(call: MethodCall, result: Result) {
    val bytes = call.argument<ByteArray>("imageBytes")
    if (bytes == null) {
      result.success(emptyList<Map<String, Any>>())
      return
    }

    val bitmap = decodeBitmap(bytes)
    if (bitmap == null) {
      result.success(emptyList<Map<String, Any>>())
      return
    }

    val image = InputImage.fromBitmap(bitmap, 0)

    // Reply from INSIDE the listeners — never by blocking this thread on a
    // CountDownLatch.
    //
    // DEADLOCK (fixed): this handler runs on the main/UI thread, and ML Kit
    // delivers `addOnSuccessListener` on that SAME main thread by default.
    // A `latch.await(...)` here therefore blocked the very thread the
    // callback needed in order to run, so the latch could never count down.
    // ML Kit's worker finished correctly ("OCR process succeeded via
    // visionkit pipeline" in logcat) and the callback simply sat queued
    // behind the blocked thread until the Dart side's own 10s timeout fired
    // and reported "no text blocks" — every single scan, on a decode that
    // had actually SUCCEEDED. The native latch was 15s vs Dart's 10s, so
    // Dart always lost the race and the native timeout was never even
    // reached.
    //
    // `result.success` is called exactly once on every path: the two
    // listeners are mutually exclusive, so no "reply already submitted"
    // error is possible.
    recognizer
      .process(image)
      .addOnSuccessListener { visionText ->
        val output = mutableListOf<Map<String, Any>>()
        for (block in visionText.textBlocks) {
          for (line in block.lines) {
            val box = line.boundingBox ?: continue
            output.add(
              mapOf(
                "text" to line.text,
                "left" to box.left.toDouble(),
                "top" to box.top.toDouble(),
                "width" to box.width().toDouble(),
                "height" to box.height().toDouble(),
                "confidence" to (line.confidence?.toDouble() ?: 0.0),
              ),
            )
          }
        }
        result.success(output)
      }
      .addOnFailureListener { error ->
        Log.w(TAG, "recognizeText failed: ${error.message}")
        result.success(emptyList<Map<String, Any>>())
      }
  }

  private fun handleDetectReceiptRect(call: MethodCall, result: Result) {
    val bytes = call.argument<ByteArray>("imageBytes")
    val bitmap = bytes?.let(::decodeBitmap)
    if (bitmap == null) {
      result.success(null)
      return
    }

    val rect = detectDocumentRect(bitmap)
    if (rect == null) {
      // design_spendlens.md §24 — a null result here is a LEGITIMATE
      // outcome, not an error; the Dart side proceeds on the original
      // image.
      result.success(null)
      return
    }

    result.success(
      mapOf(
        "left" to rect.left.toDouble(),
        "top" to rect.top.toDouble(),
        "width" to rect.width().toDouble(),
        "height" to rect.height().toDouble(),
      ),
    )
  }

  private fun handleCropPerspective(call: MethodCall, result: Result) {
    val bytes = call.argument<ByteArray>("imageBytes")
    val left = call.argument<Double>("left")
    val top = call.argument<Double>("top")
    val width = call.argument<Double>("width")
    val height = call.argument<Double>("height")

    val bitmap = bytes?.let(::decodeBitmap)
    if (bitmap == null || left == null || top == null || width == null || height == null) {
      result.success(bytes)
      return
    }

    try {
      val safeLeft = left.toInt().coerceIn(0, bitmap.width - 1)
      val safeTop = top.toInt().coerceIn(0, bitmap.height - 1)
      val safeWidth = width.toInt().coerceIn(1, bitmap.width - safeLeft)
      val safeHeight = height.toInt().coerceIn(1, bitmap.height - safeTop)

      val cropped = Bitmap.createBitmap(bitmap, safeLeft, safeTop, safeWidth, safeHeight)
      val output = ByteArrayOutputStream()
      cropped.compress(Bitmap.CompressFormat.JPEG, 92, output)
      result.success(output.toByteArray())
    } catch (error: IllegalArgumentException) {
      Log.w(TAG, "cropPerspective failed: ${error.message}")
      result.success(bytes)
    }
  }

  /// Decodes [bytes] AND applies the JPEG's EXIF orientation.
  ///
  /// `BitmapFactory` ignores the EXIF `Orientation` tag entirely, so a photo
  /// taken in portrait comes back as the sensor's native LANDSCAPE buffer
  /// (1920x1080) with the receipt lying on its side. ML Kit then reads every
  /// line correctly but reports bounding boxes in that rotated space, and the
  /// parser's line grouper — which defines "same printed line" as "similar Y,
  /// ordered by X" — sees the receipt's COLUMN axis as its row axis. The
  /// visible symptom was "TOTAL LEI" and "206.11" arriving as two blocks that
  /// never joined into one line, so no total and no items were ever resolved
  /// and a perfectly readable receipt reported `unusable_scan`.
  ///
  /// Rotating here fixes it once, for every consumer of this channel
  /// (recognizeText, detectReceiptRect, cropPerspective), rather than
  /// teaching each parser stage about orientation.
  private fun decodeBitmap(bytes: ByteArray): Bitmap? {
    return try {
      val decoded = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
        ?: return null

      val degrees = exifRotationDegrees(bytes)
      if (degrees == 0) return decoded

      val matrix = Matrix().apply { postRotate(degrees.toFloat()) }
      val rotated = Bitmap.createBitmap(
        decoded,
        0,
        0,
        decoded.width,
        decoded.height,
        matrix,
        true,
      )
      if (rotated != decoded) decoded.recycle()
      rotated
    } catch (error: OutOfMemoryError) {
      Log.w(TAG, "decodeBitmap OOM: ${error.message}")
      null
    }
  }

  /// Reads the EXIF `Orientation` tag (0x0112) straight out of the JPEG
  /// byte stream and maps it to clockwise degrees.
  ///
  /// Parsed inline rather than via `androidx.exifinterface`: that artifact is
  /// not a dependency of this module, and the only tag needed is a single
  /// SHORT in the first IFD. Any malformed/absent tag yields 0, which is the
  /// same "leave the bitmap alone" behaviour as before this method existed.
  private fun exifRotationDegrees(bytes: ByteArray): Int {
    try {
      if (bytes.size < 4) return 0
      // SOI marker — not a JPEG, nothing to read.
      if ((bytes[0].toInt() and 0xFF) != 0xFF ||
        (bytes[1].toInt() and 0xFF) != 0xD8
      ) {
        return 0
      }

      var offset = 2
      while (offset + 4 <= bytes.size) {
        if ((bytes[offset].toInt() and 0xFF) != 0xFF) return 0
        val marker = bytes[offset + 1].toInt() and 0xFF
        val segmentLength =
          ((bytes[offset + 2].toInt() and 0xFF) shl 8) or
            (bytes[offset + 3].toInt() and 0xFF)
        if (segmentLength < 2) return 0

        // APP1 carries the Exif payload.
        if (marker == 0xE1) {
          val exifStart = offset + 4
          if (exifStart + 6 > bytes.size) return 0
          val header = String(bytes, exifStart, 4, Charsets.US_ASCII)
          if (header != "Exif") return 0
          return readOrientation(bytes, exifStart + 6)
        }

        // 0xD8/0xD9 carry no length; 0xDA starts scan data (no EXIF beyond).
        if (marker == 0xDA) return 0
        offset += 2 + segmentLength
      }
      return 0
    } catch (error: RuntimeException) {
      Log.w(TAG, "exifRotationDegrees failed: ${error.message}")
      return 0
    }
  }

  private fun readOrientation(bytes: ByteArray, tiffStart: Int): Int {
    if (tiffStart + 8 > bytes.size) return 0

    val littleEndian = when (
      ((bytes[tiffStart].toInt() and 0xFF) shl 8) or
        (bytes[tiffStart + 1].toInt() and 0xFF)
    ) {
      0x4949 -> true // "II"
      0x4D4D -> false // "MM"
      else -> return 0
    }

    fun short(at: Int): Int {
      if (at + 2 > bytes.size) return -1
      val a = bytes[at].toInt() and 0xFF
      val b = bytes[at + 1].toInt() and 0xFF
      return if (littleEndian) (b shl 8) or a else (a shl 8) or b
    }

    fun int(at: Int): Int {
      if (at + 4 > bytes.size) return -1
      val a = bytes[at].toInt() and 0xFF
      val b = bytes[at + 1].toInt() and 0xFF
      val c = bytes[at + 2].toInt() and 0xFF
      val d = bytes[at + 3].toInt() and 0xFF
      return if (littleEndian) {
        (d shl 24) or (c shl 16) or (b shl 8) or a
      } else {
        (a shl 24) or (b shl 16) or (c shl 8) or d
      }
    }

    val ifdOffset = int(tiffStart + 4)
    if (ifdOffset < 0) return 0
    val ifdStart = tiffStart + ifdOffset
    val entryCount = short(ifdStart)
    if (entryCount < 0) return 0

    for (i in 0 until entryCount) {
      val entry = ifdStart + 2 + (i * 12)
      if (short(entry) == 0x0112) {
        return when (short(entry + 8)) {
          3 -> 180
          6 -> 90
          8 -> 270
          else -> 0
        }
      }
    }
    return 0
  }

  /**
   * A lightweight document-border scan: for each of the four edges, walks
   * inward from the frame border along the midline and records the first
   * point where luminance jumps by more than
   * [EDGE_LUMINANCE_DELTA_THRESHOLD] — the transition from a darker
   * background/surface to the receipt's brighter paper. No OpenCV
   * dependency; this is intentionally simple and conservative: it returns
   * `null` (never a guessed rect) whenever the resulting box would cover
   * less than [MIN_RECEIPT_AREA_FRACTION] of the frame, which is what
   * keeps a noisy/low-contrast photo from producing a nonsense crop
   * (§24 — detection failure never blocks OCR, so `null` here is always a
   * safe, legitimate outcome).
   */
  private fun detectDocumentRect(bitmap: Bitmap): Rect? {
    val width = bitmap.width
    val height = bitmap.height
    if (width <= 0 || height <= 0) return null

    val stepX = max(1, (width * EDGE_SCAN_STEP_FRACTION).toInt())
    val stepY = max(1, (height * EDGE_SCAN_STEP_FRACTION).toInt())
    val midY = height / 2
    val midX = width / 2

    val left = scanEdge(bitmap, fromX = 0, toX = width / 2, y = midY, stepX = stepX)
    val right = scanEdge(bitmap, fromX = width - 1, toX = width / 2, y = midY, stepX = -stepX)
    val top = scanEdgeVertical(bitmap, fromY = 0, toY = height / 2, x = midX, stepY = stepY)
    val bottom = scanEdgeVertical(bitmap, fromY = height - 1, toY = height / 2, x = midX, stepY = -stepY)

    if (left == null || right == null || top == null || bottom == null) return null

    val rectLeft = min(left, right)
    val rectRight = max(left, right)
    val rectTop = min(top, bottom)
    val rectBottom = max(top, bottom)
    if (rectRight <= rectLeft || rectBottom <= rectTop) return null

    val area = (rectRight - rectLeft).toLong() * (rectBottom - rectTop).toLong()
    val frameArea = width.toLong() * height.toLong()
    if (area < frameArea * MIN_RECEIPT_AREA_FRACTION) return null

    // Reject a LANDSCAPE rect. This scan samples only the middle row and the
    // middle column, which cannot bound a tall narrow receipt photographed on
    // a textured surface: the mid-row finds the paper's left/right edges
    // correctly, but the mid-column finds contrast INSIDE the printed text,
    // so the resulting rect is a wide short band through the receipt's middle.
    // It then passed the area gate (0.42 of frame > 0.15) and cropped away
    // both "TOTAL LEI" and every item line, leaving OCR real text that
    // contained no total and no items — reported downstream as
    // `unusable_scan` on a perfectly good photo.
    //
    // A receipt is always TALLER than it is wide, so a landscape result is
    // proof the scan failed rather than a detection to trust.
    // design_spendlens.md §24: returning null here is a LEGITIMATE outcome —
    // the Dart side proceeds on the ORIGINAL, uncropped image, which is
    // strictly better than proceeding on a confidently wrong crop.
    if (rectRight - rectLeft >= rectBottom - rectTop) return null

    return Rect(rectLeft, rectTop, rectRight, rectBottom)
  }

  private fun scanEdge(bitmap: Bitmap, fromX: Int, toX: Int, y: Int, stepX: Int): Int? {
    var x = fromX
    var previousLuminance = luminanceAt(bitmap, x, y)
    while (if (stepX > 0) x < toX else x > toX) {
      val nextX = x + stepX
      if (nextX < 0 || nextX >= bitmap.width) break
      val luminance = luminanceAt(bitmap, nextX, y)
      if (abs(luminance - previousLuminance) >= EDGE_LUMINANCE_DELTA_THRESHOLD) {
        return nextX
      }
      previousLuminance = luminance
      x = nextX
    }
    return null
  }

  private fun scanEdgeVertical(bitmap: Bitmap, fromY: Int, toY: Int, x: Int, stepY: Int): Int? {
    var y = fromY
    var previousLuminance = luminanceAt(bitmap, x, y)
    while (if (stepY > 0) y < toY else y > toY) {
      val nextY = y + stepY
      if (nextY < 0 || nextY >= bitmap.height) break
      val luminance = luminanceAt(bitmap, x, nextY)
      if (abs(luminance - previousLuminance) >= EDGE_LUMINANCE_DELTA_THRESHOLD) {
        return nextY
      }
      previousLuminance = luminance
      y = nextY
    }
    return null
  }

  private fun luminanceAt(bitmap: Bitmap, x: Int, y: Int): Int {
    val pixel = bitmap.getPixel(x, y)
    return (Color.red(pixel) + Color.green(pixel) + Color.blue(pixel)) / 3
  }
}

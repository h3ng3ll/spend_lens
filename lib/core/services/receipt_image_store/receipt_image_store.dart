import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Persists/reads receipt photos on the FILESYSTEM, never in Hive
/// (design_spendlens.md §3/§21): `Receipt.imagePath` stores a FILENAME
/// only; this service resolves the actual directory at read/write time
/// because the Documents path changes across iOS reinstalls.
class ReceiptImageStore {
  static const _subdirectory = 'receipts';

  const ReceiptImageStore();

  /// Saves [bytes] as `receipt_<receiptId>.jpg` and returns the FILENAME
  /// (never the full path) to store on `Receipt.imagePath`.
  Future<String> save({
    required String receiptId,
    required Uint8List bytes,
  }) async {
    final directory = await _receiptsDirectory();
    final filename = 'receipt_$receiptId.jpg';
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return filename;
  }

  /// Resolves [filename] (as stored on `Receipt.imagePath`) to a full path
  /// under the CURRENT Documents directory, or `null` if the file no
  /// longer exists on disk.
  Future<File?> resolve(String? filename) async {
    if (filename == null || filename.isEmpty) return null;
    final directory = await _receiptsDirectory();
    final file = File('${directory.path}/$filename');
    if (!await file.exists()) return null;
    return file;
  }

  Future<void> delete(String? filename) async {
    final file = await resolve(filename);
    if (file != null) {
      await file.delete();
    }
  }

  Future<Directory> _receiptsDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory('${documents.path}/$_subdirectory');
    if (!await receiptsDir.exists()) {
      await receiptsDir.create(recursive: true);
    }
    return receiptsDir;
  }
}

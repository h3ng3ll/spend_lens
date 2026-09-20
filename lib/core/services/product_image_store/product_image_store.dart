import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

/// Persists product photos on the FILESYSTEM, never in Hive and never in a
/// bloc state — the same rule `AvatarImageStore`, `ReceiptImageStore` and
/// `StoreLogoImageStore` follow, for the same reasons documented at length in
/// `AvatarImageStore`: a `Uint8List` on a freezed state makes the generator
/// emit a deep-equality compare, a deep hash and a full byte dump in
/// `toString()`, which on a real photo has already tombstoned this app's
/// process once.
///
/// `Product.imageFilename` therefore holds a FILENAME, resolved against the
/// CURRENT Documents directory at read time — the iOS Documents path changes
/// across reinstalls, so an absolute path stored today dangles tomorrow.
///
/// ## Why the committed slot is keyed per product but staging is not
///
/// A product's photo is `product_<id>.jpg`: one slot per product, overwritten
/// in place, so replacing a photo can never leak an orphan. Staging uses ONE
/// shared `product_staged.jpg` because only a single product is edited at a
/// time — the edit sheet stages, then commits or discards before another can
/// open. Keying the staging slot per product would leave a file behind for
/// every product the user ever opened and abandoned.
class ProductImageStore {
  static const _subdirectory = 'products';

  /// Where a PICKED photo waits while the sheet is still open.
  ///
  /// Separate from the committed slot so an unsaved pick never overwrites the
  /// stored photo: closing the sheet without saving must leave the product
  /// exactly as it was.
  static const _stagedFilename = 'product_staged.jpg';

  const ProductImageStore();

  /// The committed filename for [productId].
  String filenameFor(String productId) => 'product_$productId.jpg';

  /// Whether [filename] is a staged pick rather than a committed photo.
  bool isStaged(String? filename) => filename == _stagedFilename;

  /// Copies the file at [sourcePath] into the staging slot, returning its
  /// filename — or null when the source is gone.
  ///
  /// A file-to-file copy, so a multi-megabyte photo is never materialised as
  /// a `Uint8List` the caller has to hold, pass through an event, or log.
  Future<String?> stageFrom(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) return null;

    final directory = await _productsDirectory();
    final staged = await source.copy('${directory.path}/$_stagedFilename');
    await _evict(staged);
    return _stagedFilename;
  }

  /// Writes [bytes] to the staging slot and returns its filename.
  Future<String> saveStaged(Uint8List bytes) async {
    final directory = await _productsDirectory();
    final file = File('${directory.path}/$_stagedFilename');
    await file.writeAsBytes(bytes, flush: true);
    await _evict(file);
    return _stagedFilename;
  }

  /// Removes a staged pick the user did not save. Safe to call
  /// unconditionally.
  Future<void> discardStaged() => delete(_stagedFilename);

  /// Writes [bytes] as [productId]'s committed photo and returns the FILENAME
  /// to store on `Product.imageFilename`.
  Future<String> save({
    required String productId,
    required Uint8List bytes,
  }) async {
    final directory = await _productsDirectory();
    final filename = filenameFor(productId);
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    await _evict(file);
    return filename;
  }

  /// Resolves [filename] against the CURRENT Documents directory, or null
  /// when the file is absent — a reinstall, a cleared cache, or no photo.
  Future<File?> resolve(String? filename) async {
    if (filename == null || filename.isEmpty) return null;
    final directory = await _productsDirectory();
    final file = File('${directory.path}/$filename');
    if (!await file.exists()) return null;
    return file;
  }

  /// Reads the stored image back.
  ///
  /// Returns null rather than throwing when the file is gone, so a missing
  /// photo degrades to the initial-letter tile instead of taking down a
  /// screen.
  Future<Uint8List?> readBytes(String? filename) async {
    final file = await resolve(filename);
    if (file == null) return null;
    try {
      return await file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  Future<void> delete(String? filename) async {
    final file = await resolve(filename);
    if (file == null) return;

    await _evict(file);
    try {
      await file.delete();
    } catch (_) {
      // A file that cannot be deleted must not break the save: the record's
      // `imageFilename` is cleared regardless, so the image is unreachable
      // either way.
    }
  }

  /// Drops [file] from Flutter's [ImageCache] after its CONTENT changed.
  ///
  /// Both slots are fixed filenames overwritten in place, and `Image.file`
  /// keys the cache on `(path, scale)` — not on the bytes. Without this, a
  /// second pick writes a new photo to the same path while every product
  /// image on screen keeps decoding the FIRST one out of the cache. Evicting
  /// at the one place that writes keeps the rule with the mutation, rather
  /// than asking each product surface to remember it.
  Future<void> _evict(File file) => FileImage(file).evict();

  Future<Directory> _productsDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final productsDir = Directory('${documents.path}/$_subdirectory');
    if (!await productsDir.exists()) {
      await productsDir.create(recursive: true);
    }
    return productsDir;
  }
}

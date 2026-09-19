import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

/// Persists store logos on the FILESYSTEM, never in Hive and never in a bloc
/// state — the same rule [AvatarImageStore] and [ReceiptImageStore] follow,
/// for the same reasons documented at length in `AvatarImageStore`: a
/// `Uint8List` on a freezed state makes the generator emit a deep-equality
/// compare, a deep hash and a full byte dump in `toString()`, which on a real
/// photo has already tombstoned this app's process once.
///
/// `Store.logoFilename` therefore holds a FILENAME, resolved against the
/// CURRENT Documents directory at read time — the iOS Documents path changes
/// across reinstalls, so an absolute path stored today dangles tomorrow.
///
/// ## Why the committed slot is keyed per store but staging is not
///
/// A store's logo is `store_<id>.jpg`: one slot per store, overwritten in
/// place, so replacing a logo can never leak an orphan. Staging uses ONE
/// shared `store_staged.jpg` because only a single store is edited at a time
/// — the edit sheet stages, then commits or discards before another can open.
/// Keying the staging slot per store would leave a file behind for every
/// store the user ever opened and abandoned.
class StoreLogoImageStore {
  static const _subdirectory = 'stores';

  /// Where a PICKED logo waits while the sheet is still open.
  ///
  /// Separate from the committed slot so an unsaved pick never overwrites the
  /// stored logo: closing the sheet without saving must leave the store
  /// exactly as it was.
  static const _stagedFilename = 'store_staged.jpg';

  const StoreLogoImageStore();

  /// The committed filename for [storeId].
  String filenameFor(String storeId) => 'store_$storeId.jpg';

  /// Whether [filename] is a staged pick rather than a committed logo.
  bool isStaged(String? filename) => filename == _stagedFilename;

  /// Copies the file at [sourcePath] into the staging slot, returning its
  /// filename — or null when the source is gone.
  ///
  /// A file-to-file copy, so a multi-megabyte photo is never materialised as
  /// a `Uint8List` the caller has to hold, pass through an event, or log.
  Future<String?> stageFrom(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) return null;

    final directory = await _storesDirectory();
    final staged = await source.copy('${directory.path}/$_stagedFilename');
    await _evict(staged);
    return _stagedFilename;
  }

  /// Writes [bytes] to the staging slot and returns its filename.
  Future<String> saveStaged(Uint8List bytes) async {
    final directory = await _storesDirectory();
    final file = File('${directory.path}/$_stagedFilename');
    await file.writeAsBytes(bytes, flush: true);
    await _evict(file);
    return _stagedFilename;
  }

  /// Removes a staged pick the user did not save. Safe to call
  /// unconditionally.
  Future<void> discardStaged() => delete(_stagedFilename);

  /// Writes [bytes] as [storeId]'s committed logo and returns the FILENAME to
  /// store on `Store.logoFilename`.
  Future<String> save({
    required String storeId,
    required Uint8List bytes,
  }) async {
    final directory = await _storesDirectory();
    final filename = filenameFor(storeId);
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    await _evict(file);
    return filename;
  }

  /// Resolves [filename] against the CURRENT Documents directory, or null
  /// when the file is absent — a reinstall, a cleared cache, or no logo.
  Future<File?> resolve(String? filename) async {
    if (filename == null || filename.isEmpty) return null;
    final directory = await _storesDirectory();
    final file = File('${directory.path}/$filename');
    if (!await file.exists()) return null;
    return file;
  }

  /// Reads the stored image back.
  ///
  /// Returns null rather than throwing when the file is gone, so a missing
  /// logo degrades to the initial-letter tile instead of taking down a screen.
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
      // `logoFilename` is cleared regardless, so the image is unreachable
      // either way.
    }
  }

  /// Drops [file] from Flutter's [ImageCache] after its CONTENT changed.
  ///
  /// Both slots are fixed filenames overwritten in place, and `Image.file`
  /// keys the cache on `(path, scale)` — not on the bytes. Without this, a
  /// second pick writes a new photo to the same path while every logo on
  /// screen keeps decoding the FIRST one out of the cache. Evicting at the
  /// one place that writes keeps the rule with the mutation, rather than
  /// asking each logo surface to remember it.
  Future<void> _evict(File file) => FileImage(file).evict();

  Future<Directory> _storesDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final storesDir = Directory('${documents.path}/$_subdirectory');
    if (!await storesDir.exists()) {
      await storesDir.create(recursive: true);
    }
    return storesDir;
  }
}

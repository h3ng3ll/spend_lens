import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

/// Persists the signed-in user's avatar on the FILESYSTEM, never in Hive and
/// never in a bloc state — the same rule `ReceiptImageStore` follows for
/// receipt photos, and for the same reasons.
///
/// ## Why the bytes must not live in state or in Hive
///
/// A `Uint8List` field on a freezed state makes the generator emit
/// `DeepCollectionEquality().equals(...)` in `==`, the same in `hashCode`, and
/// `$bytes` in `toString()`. On a real photo that is ruinous, and it has now
/// cost this codebase two separate defects:
///
/// * `ReviewState` — a receipt image re-compared on every keystroke. Fixed by
///   storing the filename (see that file's header comment).
/// * `EditProfileState` / `AuthState` — the avatar. `toString()` rendered
///   ~12 MB of bytes as a 57 MB decimal string, which `AppObserver` then built
///   FOUR times per Save on the main isolate. The platform tombstoned the
///   process: `Wrote stack traces to tombstoned`, then `Lost connection`.
///
/// Measured on a desktop for a 12 MB image — a phone is markedly slower:
/// `DeepCollectionEquality.equals` 36 ms, `.hash` 32 ms, `toString()` 309 ms.
///
/// Holding a FILENAME removes the whole class of problem rather than making it
/// cheaper: a `String` is trivially comparable, printable, and small, so no
/// future field can reintroduce the cost by accident.
///
/// ## Why a filename and not a full path
///
/// The Documents directory changes across iOS reinstalls, so an absolute path
/// stored today can dangle tomorrow. Callers store the FILENAME and resolve it
/// against the CURRENT directory at read time — exactly as `Receipt.imagePath`
/// does.
class AvatarImageStore {
  static const _subdirectory = 'profile';

  /// Stable name: the avatar is a single-slot image, so writing always
  /// overwrites in place and can never leak orphaned files.
  static const _filename = 'avatar.jpg';

  /// Where a PICKED image waits while the user is still editing.
  ///
  /// Separate from [_filename] so an unsaved pick never overwrites the stored
  /// avatar: leaving the screen without saving must leave the profile exactly
  /// as it was (`edit_profile_screen_rules.md` rule 3).
  static const _stagedFilename = 'avatar_staged.jpg';

  const AvatarImageStore();

  /// Writes a freshly picked image to the STAGING slot and returns its
  /// filename, so the edit screen can render and later commit it without ever
  /// holding the bytes in a bloc state.
  Future<String> saveStaged(Uint8List bytes) async {
    final directory = await _profileDirectory();
    final file = File('${directory.path}/$_stagedFilename');
    await file.writeAsBytes(bytes, flush: true);
    await _evict(file);
    return _stagedFilename;
  }

  /// Copies the file at [sourcePath] into the staging slot, returning its
  /// filename — or null when the source is gone.
  ///
  /// A file-to-file copy, so a multi-megabyte photo is never materialised as a
  /// `Uint8List` the caller has to hold, pass through an event, or accidentally
  /// log.
  Future<String?> stageFrom(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) return null;

    final directory = await _profileDirectory();
    final staged = await source.copy('${directory.path}/$_stagedFilename');
    await _evict(staged);
    return _stagedFilename;
  }

  /// Whether [filename] is a staged pick rather than the committed avatar.
  bool isStaged(String? filename) => filename == _stagedFilename;

  /// Removes a staged pick the user did not save. Safe to call unconditionally.
  Future<void> discardStaged() => delete(_stagedFilename);

  /// Writes [bytes] and returns the FILENAME to store on the profile.
  Future<String> save(Uint8List bytes) async {
    final directory = await _profileDirectory();
    final file = File('${directory.path}/$_filename');
    await file.writeAsBytes(bytes, flush: true);
    await _evict(file);
    return _filename;
  }

  /// Resolves [filename] against the CURRENT Documents directory, or null when
  /// the file is absent — a reinstall, a cleared cache, or a never-set avatar.
  Future<File?> resolve(String? filename) async {
    if (filename == null || filename.isEmpty) return null;
    final directory = await _profileDirectory();
    final file = File('${directory.path}/$filename');
    if (!await file.exists()) return null;
    return file;
  }

  /// Reads the stored image back.
  ///
  /// Returns null rather than throwing when the file is gone, so a missing
  /// avatar degrades to the placeholder instead of taking down the screen.
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
    if (file != null) {
      await _evict(file);
      try {
        await file.delete();
      } catch (_) {
        // A file that cannot be deleted must not break sign-out: the profile
        // record is cleared regardless, so the image is unreachable either way.
      }
    }
  }

  /// Drops [file] from Flutter's [ImageCache] after its CONTENT changed.
  ///
  /// Both slots are fixed filenames that are overwritten in place, and
  /// `Image.file` keys the cache on `(path, scale)` — not on the bytes. So a
  /// second pick wrote a new photo to the same path and every avatar on screen
  /// kept decoding the FIRST one out of the cache: the image never changed
  /// while Save correctly enabled itself, because the state (`hasPickedAvatar`)
  /// had in fact moved. The commit slot has the same shape, so saving a new
  /// photo left Profile and Settings showing the old face until a restart.
  ///
  /// Evicting here — at the one place that writes — keeps the rule with the
  /// mutation instead of asking each of the four avatar surfaces to remember
  /// it. [FileImage.evict] resolves the key itself, so this stays correct if
  /// the widgets ever change how they build the provider.
  Future<void> _evict(File file) => FileImage(file).evict();

  Future<Directory> _profileDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final profileDir = Directory('${documents.path}/$_subdirectory');
    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }
    return profileDir;
  }
}

import 'dart:convert';

import 'models/backup_bundle/backup_bundle.dart';

/// Thrown by [BackupJsonCodec.decode] when a payload's `schemaVersion` is
/// newer than this app understands (design_spendlens.md §6/§61 — import
/// "validates the schema and migrates, never blind-overwrites"). A FUTURE
/// version is the one case this app cannot silently migrate down from — the
/// fields it would need to drop are unknown, not merely absent.
class BackupSchemaTooNewException implements Exception {
  final int foundVersion;
  final int maxSupportedVersion;

  const BackupSchemaTooNewException({
    required this.foundVersion,
    required this.maxSupportedVersion,
  });

  @override
  String toString() =>
      'BackupSchemaTooNewException(found: $foundVersion, '
      'maxSupported: $maxSupportedVersion)';
}

/// Thrown when the payload is not a recognizable backup at all (missing the
/// top-level object shape, or `schemaVersion` is not an int).
class BackupMalformedException implements Exception {
  final String reason;

  const BackupMalformedException(this.reason);

  @override
  String toString() => 'BackupMalformedException($reason)';
}

/// Canonical JSON encode/decode for [BackupBundle]
/// (design_spendlens.md §6/§9/§11).
///
/// **Never blind-overwrites (spec §61).** [decode] is the single gate every
/// imported byte stream passes through:
/// - `schemaVersion` MISSING → treated as version 1 (the oldest shape this
///   app has ever produced) and migrated forward.
/// - `schemaVersion` OLDER than [currentSchemaVersion] → migrated forward
///   field-by-field via [_migrate]; unknown/missing fields default through
///   each model's own `fromJson` (freezed's generated decoder already
///   supplies `@Default` values for absent keys).
/// - `schemaVersion` NEWER than [currentSchemaVersion] → rejected with
///   [BackupSchemaTooNewException] rather than guessed at — a newer schema
///   may carry fields this binary cannot interpret, and importing a partial
///   read of it would be a silent, undetectable data loss on the NEXT
///   export.
/// - Any other structural problem (not a JSON object, an entity list entry
///   that fails its own `fromJson`) surfaces as an exception the caller
///   reports to the user; nothing is written to Hive until decode succeeds.
abstract class BackupJsonCodec {
  /// The schema version THIS build writes and the newest it accepts reading.
  static const int currentSchemaVersion = 1;

  static String encode(BackupBundle bundle) {
    return jsonEncode(bundle.toJson());
  }

  static BackupBundle decode(String raw) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException catch (e) {
      throw BackupMalformedException('not valid JSON: $e');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const BackupMalformedException('root is not a JSON object');
    }

    final rawVersion = decoded['schemaVersion'];
    final foundVersion = rawVersion is int ? rawVersion : 1;

    if (foundVersion > currentSchemaVersion) {
      throw BackupSchemaTooNewException(
        foundVersion: foundVersion,
        maxSupportedVersion: currentSchemaVersion,
      );
    }

    final migrated = _migrate(decoded, fromVersion: foundVersion);

    return BackupBundle.fromJson(migrated);
  }

  /// Forward-migrates a decoded JSON map from [fromVersion] up to
  /// [currentSchemaVersion]. There has been exactly one schema shape so far
  /// (version 1), so this is currently the identity transform plus stamping
  /// the version field — the seam every future migration step appends to,
  /// never replaces.
  static Map<String, dynamic> _migrate(
    Map<String, dynamic> json, {
    required int fromVersion,
  }) {
    final migrated = Map<String, dynamic>.from(json);
    migrated['schemaVersion'] = currentSchemaVersion;
    migrated['exportedAt'] ??= DateTime.now().toIso8601String();
    migrated['receipts'] ??= <dynamic>[];
    migrated['receiptItems'] ??= <dynamic>[];
    migrated['products'] ??= <dynamic>[];
    migrated['stores'] ??= <dynamic>[];
    migrated['categories'] ??= <dynamic>[];
    migrated['expenses'] ??= <dynamic>[];
    migrated['priceObservations'] ??= <dynamic>[];
    return migrated;
  }
}

import 'package:hive_ce/hive.dart';

import '../../features/settings/domain/models/app_settings/e_app_theme_mode.dart';

/// Manually-written enum adapters (hive_rules.md §3).
///
/// Auto-generated model adapters (`@GenerateAdapters`) occupy typeIds 0–99;
/// every manual enum adapter here MUST use typeIds ≥ 100 to avoid collision.
/// Only enums that are actually a `@HiveField`-equivalent (i.e. a field of a
/// model listed in `@GenerateAdapters`) get registered — `EAppThemeMode` is a
/// field of `AppSettings`, so it qualifies.
class EAppThemeModeAdapter extends TypeAdapter<EAppThemeMode> {
  @override
  final int typeId = 100;

  @override
  EAppThemeMode read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= EAppThemeMode.values.length) {
      return EAppThemeMode.system;
    }
    return EAppThemeMode.values[index];
  }

  @override
  void write(BinaryWriter writer, EAppThemeMode obj) {
    writer.writeByte(obj.index);
  }
}

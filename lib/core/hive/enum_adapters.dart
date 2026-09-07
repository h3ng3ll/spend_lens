import 'package:hive_ce/hive.dart';

import '../../features/expense/domain/models/expense/e_expense_source.dart';
import '../../features/product/domain/models/product/e_unit.dart';
import '../../features/settings/domain/models/app_settings/e_app_theme_mode.dart';
import '../../features/settings/domain/models/app_settings/e_flash_mode.dart';
import '../../features/store/domain/models/store/e_store_type.dart';
import '../models/e_sync_status.dart';

/// Manually-written enum adapters (hive_rules.md §3).
///
/// Auto-generated model adapters (`@GenerateAdapters`) occupy typeIds 0–99;
/// every manual enum adapter here MUST use typeIds ≥ 100 to avoid collision.
/// Only enums that are actually a field of a model listed in
/// `@GenerateAdapters` get registered — all six below qualify:
/// `EAppThemeMode`/`EFlashMode` (`AppSettings`), `ESyncStatus` (every M3
/// model), `EUnit` (`ReceiptItem`/`Product`/`PriceObservation`),
/// `EStoreType` (`Store`), `EExpenseSource` (`Expense`).
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

class ESyncStatusAdapter extends TypeAdapter<ESyncStatus> {
  @override
  final int typeId = 101;

  @override
  ESyncStatus read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= ESyncStatus.values.length) {
      return ESyncStatus.synced;
    }
    return ESyncStatus.values[index];
  }

  @override
  void write(BinaryWriter writer, ESyncStatus obj) {
    writer.writeByte(obj.index);
  }
}

class EUnitAdapter extends TypeAdapter<EUnit> {
  @override
  final int typeId = 102;

  @override
  EUnit read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= EUnit.values.length) {
      return EUnit.piece;
    }
    return EUnit.values[index];
  }

  @override
  void write(BinaryWriter writer, EUnit obj) {
    writer.writeByte(obj.index);
  }
}

class EStoreTypeAdapter extends TypeAdapter<EStoreType> {
  @override
  final int typeId = 103;

  @override
  EStoreType read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= EStoreType.values.length) {
      return EStoreType.other;
    }
    return EStoreType.values[index];
  }

  @override
  void write(BinaryWriter writer, EStoreType obj) {
    writer.writeByte(obj.index);
  }
}

class EExpenseSourceAdapter extends TypeAdapter<EExpenseSource> {
  @override
  final int typeId = 104;

  @override
  EExpenseSource read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= EExpenseSource.values.length) {
      return EExpenseSource.cash;
    }
    return EExpenseSource.values[index];
  }

  @override
  void write(BinaryWriter writer, EExpenseSource obj) {
    writer.writeByte(obj.index);
  }
}

class EFlashModeAdapter extends TypeAdapter<EFlashMode> {
  @override
  final int typeId = 105;

  @override
  EFlashMode read(BinaryReader reader) {
    final index = reader.readByte();
    if (index < 0 || index >= EFlashMode.values.length) {
      return EFlashMode.auto;
    }
    return EFlashMode.values[index];
  }

  @override
  void write(BinaryWriter writer, EFlashMode obj) {
    writer.writeByte(obj.index);
  }
}

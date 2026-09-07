// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final typeId = 0;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      localeCode: fields[0] as String?,
      currencyCode: fields[1] == null ? 'MDL' : fields[1] as String,
      themeMode: fields[2] == null
          ? EAppThemeMode.system
          : fields[2] as EAppThemeMode,
      onboardingCompleted: fields[3] == null ? false : fields[3] as bool,
      flashMode: fields[4] == null ? EFlashMode.auto : fields[4] as EFlashMode,
      dataCleared: fields[5] == null ? false : fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.localeCode)
      ..writeByte(1)
      ..write(obj.currencyCode)
      ..writeByte(2)
      ..write(obj.themeMode)
      ..writeByte(3)
      ..write(obj.onboardingCompleted)
      ..writeByte(4)
      ..write(obj.flashMode)
      ..writeByte(5)
      ..write(obj.dataCleared);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReceiptAdapter extends TypeAdapter<Receipt> {
  @override
  final typeId = 1;

  @override
  Receipt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Receipt(
      id: fields[0] as String,
      storeId: fields[1] as String?,
      purchasedAt: fields[2] as DateTime,
      printedTotal: (fields[3] as num?)?.toDouble(),
      itemsTotal: (fields[4] as num).toDouble(),
      discount: (fields[5] as num?)?.toDouble(),
      currencyCode: fields[6] as String,
      categoryId: fields[7] as String?,
      imagePath: fields[8] as String?,
      itemIds: fields[9] == null ? [] : (fields[9] as List).cast<String>(),
      isReconciled: fields[10] == null ? false : fields[10] as bool,
      updatedAt: fields[11] as DateTime,
      deletedAt: fields[12] as DateTime?,
      syncStatus: fields[13] == null
          ? ESyncStatus.synced
          : fields[13] as ESyncStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Receipt obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.storeId)
      ..writeByte(2)
      ..write(obj.purchasedAt)
      ..writeByte(3)
      ..write(obj.printedTotal)
      ..writeByte(4)
      ..write(obj.itemsTotal)
      ..writeByte(5)
      ..write(obj.discount)
      ..writeByte(6)
      ..write(obj.currencyCode)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.imagePath)
      ..writeByte(9)
      ..write(obj.itemIds)
      ..writeByte(10)
      ..write(obj.isReconciled)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.deletedAt)
      ..writeByte(13)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReceiptItemAdapter extends TypeAdapter<ReceiptItem> {
  @override
  final typeId = 2;

  @override
  ReceiptItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReceiptItem(
      id: fields[0] as String,
      rawName: fields[1] as String,
      normalizedName: fields[2] as String,
      productId: fields[3] as String?,
      quantity: (fields[4] as num).toDouble(),
      unit: fields[5] == null ? EUnit.piece : fields[5] as EUnit,
      unitPrice: (fields[6] as num?)?.toDouble(),
      lineTotal: (fields[7] as num).toDouble(),
      confidence: (fields[8] as num).toDouble(),
      isLowConfidence: fields[9] == null ? false : fields[9] as bool,
      isManuallyAdded: fields[10] == null ? false : fields[10] as bool,
      lineIndex: (fields[11] as num).toInt(),
      updatedAt: fields[12] as DateTime,
      deletedAt: fields[13] as DateTime?,
      syncStatus: fields[14] == null
          ? ESyncStatus.synced
          : fields[14] as ESyncStatus,
    );
  }

  @override
  void write(BinaryWriter writer, ReceiptItem obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rawName)
      ..writeByte(2)
      ..write(obj.normalizedName)
      ..writeByte(3)
      ..write(obj.productId)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.unitPrice)
      ..writeByte(7)
      ..write(obj.lineTotal)
      ..writeByte(8)
      ..write(obj.confidence)
      ..writeByte(9)
      ..write(obj.isLowConfidence)
      ..writeByte(10)
      ..write(obj.isManuallyAdded)
      ..writeByte(11)
      ..write(obj.lineIndex)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.deletedAt)
      ..writeByte(14)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final typeId = 3;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      normalizedName: fields[1] as String,
      displayName: fields[2] as String,
      aliases: fields[3] == null ? [] : (fields[3] as List).cast<String>(),
      defaultCategoryId: fields[4] as String?,
      defaultUnit: fields[5] == null ? EUnit.piece : fields[5] as EUnit,
      updatedAt: fields[6] as DateTime,
      deletedAt: fields[7] as DateTime?,
      syncStatus: fields[8] == null
          ? ESyncStatus.synced
          : fields[8] as ESyncStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.normalizedName)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.aliases)
      ..writeByte(4)
      ..write(obj.defaultCategoryId)
      ..writeByte(5)
      ..write(obj.defaultUnit)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.deletedAt)
      ..writeByte(8)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final typeId = 4;

  @override
  Store read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Store(
      id: fields[0] as String,
      name: fields[1] as String,
      receiptAliases: fields[2] == null
          ? []
          : (fields[2] as List).cast<String>(),
      type: fields[3] == null ? EStoreType.other : fields[3] as EStoreType,
      updatedAt: fields[4] as DateTime,
      deletedAt: fields[5] as DateTime?,
      syncStatus: fields[6] == null
          ? ESyncStatus.synced
          : fields[6] as ESyncStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.receiptAliases)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.deletedAt)
      ..writeByte(6)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 5;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      colorHex: fields[2] as String,
      isBuiltIn: fields[3] as bool,
      keywords: fields[4] == null ? [] : (fields[4] as List).cast<String>(),
      updatedAt: fields[5] as DateTime,
      deletedAt: fields[6] as DateTime?,
      syncStatus: fields[7] == null
          ? ESyncStatus.synced
          : fields[7] as ESyncStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorHex)
      ..writeByte(3)
      ..write(obj.isBuiltIn)
      ..writeByte(4)
      ..write(obj.keywords)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.deletedAt)
      ..writeByte(7)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final typeId = 6;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      id: fields[0] as String,
      amount: (fields[1] as num).toDouble(),
      currencyCode: fields[2] as String,
      categoryId: fields[3] as String,
      storeId: fields[4] as String?,
      note: fields[5] as String?,
      occurredAt: fields[6] as DateTime,
      source: fields[7] == null
          ? EExpenseSource.cash
          : fields[7] as EExpenseSource,
      updatedAt: fields[8] as DateTime,
      deletedAt: fields[9] as DateTime?,
      syncStatus: fields[10] == null
          ? ESyncStatus.synced
          : fields[10] as ESyncStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.currencyCode)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.storeId)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.occurredAt)
      ..writeByte(7)
      ..write(obj.source)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.deletedAt)
      ..writeByte(10)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriceObservationAdapter extends TypeAdapter<PriceObservation> {
  @override
  final typeId = 7;

  @override
  PriceObservation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceObservation(
      id: fields[0] as String,
      productId: fields[1] as String,
      storeId: fields[2] as String?,
      receiptId: fields[3] as String,
      observedAt: fields[4] as DateTime,
      comparableUnitPrice: (fields[5] as num).toDouble(),
      unit: fields[6] == null ? EUnit.piece : fields[6] as EUnit,
      currencyCode: fields[7] as String,
      updatedAt: fields[8] as DateTime,
      deletedAt: fields[9] as DateTime?,
      syncStatus: fields[10] == null
          ? ESyncStatus.synced
          : fields[10] as ESyncStatus,
    );
  }

  @override
  void write(BinaryWriter writer, PriceObservation obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.storeId)
      ..writeByte(3)
      ..write(obj.receiptId)
      ..writeByte(4)
      ..write(obj.observedAt)
      ..writeByte(5)
      ..write(obj.comparableUnitPrice)
      ..writeByte(6)
      ..write(obj.unit)
      ..writeByte(7)
      ..write(obj.currencyCode)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.deletedAt)
      ..writeByte(10)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceObservationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

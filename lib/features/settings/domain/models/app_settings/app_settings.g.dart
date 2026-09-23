// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  localeCode: json['localeCode'] as String?,
  currencyCode: json['currencyCode'] as String? ?? 'MDL',
  themeMode:
      $enumDecodeNullable(_$EAppThemeModeEnumMap, json['themeMode']) ??
      EAppThemeMode.system,
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
  flashMode:
      $enumDecodeNullable(_$EFlashModeEnumMap, json['flashMode']) ??
      EFlashMode.auto,
  dataCleared: json['dataCleared'] as bool? ?? false,
  lastSyncedAt: json['lastSyncedAt'] as String?,
  legacyPullCompleted: json['legacyPullCompleted'] as bool? ?? false,
  productsSplitCompleted: json['productsSplitCompleted'] as bool? ?? false,
  scanFrameLeft: (json['scanFrameLeft'] as num?)?.toDouble(),
  scanFrameTop: (json['scanFrameTop'] as num?)?.toDouble(),
  scanFrameWidth: (json['scanFrameWidth'] as num?)?.toDouble(),
  scanFrameHeight: (json['scanFrameHeight'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'localeCode': instance.localeCode,
      'currencyCode': instance.currencyCode,
      'themeMode': _$EAppThemeModeEnumMap[instance.themeMode]!,
      'onboardingCompleted': instance.onboardingCompleted,
      'flashMode': _$EFlashModeEnumMap[instance.flashMode]!,
      'dataCleared': instance.dataCleared,
      'lastSyncedAt': instance.lastSyncedAt,
      'legacyPullCompleted': instance.legacyPullCompleted,
      'productsSplitCompleted': instance.productsSplitCompleted,
      'scanFrameLeft': instance.scanFrameLeft,
      'scanFrameTop': instance.scanFrameTop,
      'scanFrameWidth': instance.scanFrameWidth,
      'scanFrameHeight': instance.scanFrameHeight,
    };

const _$EAppThemeModeEnumMap = {
  EAppThemeMode.system: 'system',
  EAppThemeMode.light: 'light',
  EAppThemeMode.dark: 'dark',
};

const _$EFlashModeEnumMap = {
  EFlashMode.auto: 'auto',
  EFlashMode.on: 'on',
  EFlashMode.off: 'off',
};

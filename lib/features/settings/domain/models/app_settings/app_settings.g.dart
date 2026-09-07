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
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'localeCode': instance.localeCode,
      'currencyCode': instance.currencyCode,
      'themeMode': _$EAppThemeModeEnumMap[instance.themeMode]!,
    };

const _$EAppThemeModeEnumMap = {
  EAppThemeMode.system: 'system',
  EAppThemeMode.light: 'light',
  EAppThemeMode.dark: 'dark',
};

import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../extensions/color_ext.dart';

class ColorSerializable implements JsonConverter<Color, String> {
  const ColorSerializable();

  @override
  Color fromJson(String value) {
    return ColorExtension.fromHex(value);
  }

  @override
  String toJson(Color color) {
    final String hexValue = color.toHex(
      leadingHashSign: false,
    );
    return hexValue;
  }
}

import 'package:flutter/cupertino.dart';

extension ScrollControllerExt on ScrollController {
  bool get reachToEnd => position.pixels >= position.maxScrollExtent - 300;

  bool get reachMaxPosition => position.pixels >= position.maxScrollExtent;

  bool get atBeginPosition => position.pixels <= position.minScrollExtent;
}

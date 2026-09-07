import 'package:flutter/material.dart';

import 'app_container.dart';

/// The small colored dot used to mark a category throughout the app (chips,
/// legends, list rows, badges). Layout-only (A6): receives its color.
class CategoryDot extends StatelessWidget {
  final Color color;
  final double size;

  const CategoryDot({super.key, required this.color, this.size = 8.0});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: size,
      height: size,
      color: color,
      shape: BoxShape.circle,
    );
  }
}

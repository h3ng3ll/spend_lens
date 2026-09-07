import 'package:flutter/material.dart';

enum HorizontalPaddingSize {
  small,
  medium,
  big,
}

class HorizontalPadding extends StatelessWidget {
  final Widget child;
  final HorizontalPaddingSize horizontalPaddingSize;

  const HorizontalPadding({
    super.key,
    required this.child,
    this.horizontalPaddingSize = HorizontalPaddingSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final size = horizontalPaddingSize == HorizontalPaddingSize.medium
        ? 16.0
        : horizontalPaddingSize == HorizontalPaddingSize.big
            ? 47.0
            : horizontalPaddingSize == HorizontalPaddingSize.small
                ? 5.0
                : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size,
      ),
      child: child,
    );
  }
}

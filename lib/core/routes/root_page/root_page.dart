import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  final Widget navigator;

  const RootPage({
    super.key,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    return navigator;
  }
}

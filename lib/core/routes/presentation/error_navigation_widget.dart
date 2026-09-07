import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorNavigationWidget extends StatelessWidget {
  final GoRouterState routerState;

  const ErrorNavigationWidget({super.key, required this.routerState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Cant go to the'),
              Text(routerState.error?.message ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HafalanScreen extends StatelessWidget {
  const HafalanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Hafalan Screen')),
    );
  }
}

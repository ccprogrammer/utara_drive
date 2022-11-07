import 'package:flutter/material.dart';

class NoScreen extends StatelessWidget {
  const NoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('No Page Found'),
      ),
    );
  }
}

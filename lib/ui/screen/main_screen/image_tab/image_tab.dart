import 'package:flutter/material.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Image Tab'),
      ),
    );
  }
}

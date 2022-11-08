import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  const ImageGrid({super.key, this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageUrl ?? 'assets/images/image_background.png',
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}

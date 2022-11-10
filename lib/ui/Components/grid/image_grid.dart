import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  const ImageGrid({super.key, this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      data['image_url'] ??
          'https://images.unsplash.com/photo-1488161628813-04466f872be2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80',
      height: MediaQuery.of(context).size.height * 0.4,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/photos_grid.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.colorWhite,
      body: ListView(
        children: [
          const Text(
            'Photos',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyTheme.colorCream,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < 3; i++)
            PhotosGrid(gridNumber: Random().nextInt(9)),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

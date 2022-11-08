import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:utara_drive/data/grid_model.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/image_grid.dart';

class PhotosGrid extends StatefulWidget {
  const PhotosGrid({super.key, required this.gridNumber});
  final int gridNumber;

  @override
  State<PhotosGrid> createState() => _PhotosGridState();
}

class _PhotosGridState extends State<PhotosGrid> {
 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16),
            child: const Text(
              'November',
              style: TextStyle(
                color: MyTheme.colorDarkerGrey,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 18),
          StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              for (var item in MyGrid.gridModel[widget.gridNumber])
                StaggeredGridTile.count(
                  crossAxisCellCount: item['cross'],
                  mainAxisCellCount: item['main'],
                  child: const ImageGrid(),
                )
            ],
          ),
        ],
      ),
    );
  }
}

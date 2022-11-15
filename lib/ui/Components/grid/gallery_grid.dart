import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:utara_drive/ui/Components/grid/gallery_grid_item.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid(
      {super.key, required this.scrollController, required this.galleryList});
  final ScrollController scrollController;
  final List galleryList;

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      shrinkWrap: true,
      controller: scrollController,
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.mirrored,
        pattern: [
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: galleryList.length,
        (context, index) {
          dynamic item = galleryList
              .where((element) => element.id == galleryList[index].id)
              .toList()[0];

          return GalleryGridItem(data: item);
        },
      ),
    );
  }
}

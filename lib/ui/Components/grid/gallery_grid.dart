import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:utara_drive/ui/Components/grid/gallery_grid_image_item.dart';
import 'package:utara_drive/ui/Components/grid/gallery_grid_video_item.dart';

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

          if (item['type'] == 'image') {
            return GalleryGridImageItem(data: item);
          } else if (item['type'] == 'video') {
            return GalleryGridVideoItem(data: item);
          }
          return null;
        },
      ),
    );
  }
}

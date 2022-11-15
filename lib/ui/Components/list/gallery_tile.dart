import 'package:flutter/material.dart';
import 'package:utara_drive/ui/Components/list/gallery_tile_item.dart';

class GalleryTile extends StatelessWidget {
  const GalleryTile(
      {super.key, required this.scrollController, required this.galleryList});
  final ScrollController scrollController;
  final List galleryList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      controller: scrollController,
      separatorBuilder: (context, index) => const Divider(height: 42),
      itemCount: galleryList.length,
      itemBuilder: (context, index) {
        dynamic item = galleryList
            .where((element) => element.id == galleryList[index].id)
            .toList()[0];

        int idx = galleryList.indexOf(item);

        return Padding(
          padding:
              EdgeInsets.only(bottom: idx == galleryList.length - 1 ? 42 : 0),
          child: GalleryTileItem(
            item: item,
          ),
        );
      },
    );
  }
}

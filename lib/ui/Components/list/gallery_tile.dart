import 'package:flutter/material.dart';
import 'package:utara_drive/ui/Components/list/gallery_tile_item.dart';

Widget galleryTile(List galleryList) {
  return ListView.separated(
    separatorBuilder: (context, index) => const Divider(height: 42),
    itemCount: galleryList.length,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      dynamic item = galleryList
          .where((element) => element.id == galleryList[index].id)
          .toList()[0];

      return GalleryTileItem(
        item: item,
      );
    },
  );
}

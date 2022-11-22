import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class GalleryTileImageItem extends StatelessWidget {
  const GalleryTileImageItem({super.key, this.item});
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: CachedNetworkImage(
        imageUrl: item['file_url'],
        imageBuilder: (context, imageProvider) {
          return Column(
            children: [
              // title tile
              Row(
                children: [
                  const Icon(
                    Icons.image,
                    color: MyTheme.colorDarkGrey,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['label'] != '' ? item['label'] : item['image_name'],
                      style: const TextStyle(
                        color: MyTheme.colorDarkGrey,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),

              // image tile
              Hero(
                tag: item is QueryDocumentSnapshot ? item.id : item['id'],
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.detailImage,
                            arguments: item);
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        placeholder: (context, url) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[300]!,
            child: Column(
              children: [
                Row(
                  children: const [
                    Skeleton(
                      width: 20,
                      height: 18,
                      radius: 4,
                      marginRight: 8,
                    ),
                    Skeleton(
                      width: 130,
                      height: 18,
                      radius: 4,
                    )
                  ],
                ),
                const Skeleton(marginTop: 16),
                const Skeleton(
                  height: 150,
                  radius: 16,
                ),
              ],
            ),
          ),
        ),
        errorWidget: (context, url, error) => Column(
          children: [
            Row(
              children: [
                Icon(
                  item['type'] == 'image'
                      ? Icons.image
                      : Icons.slow_motion_video_rounded,
                  color: MyTheme.colorDarkerGrey,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  item['label'] != '' ? item['label'] : item['image_name'],
                  style: const TextStyle(
                    color: MyTheme.colorDarkerGrey,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: const Center(
                child: Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

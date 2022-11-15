import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class GalleryTileItem extends StatelessWidget {
  const GalleryTileItem({super.key, this.item});
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      
      child: CachedNetworkImage(
        imageUrl: item['image_url'],
        imageBuilder: (context, imageProvider) {
          return Column(
            children: [

              // title tile
              Row(
                children: [
                  Icon(
                    item['type'] == 'image'
                        ? Icons.image
                        : Icons.slow_motion_video_rounded,
                    color: MyTheme.colorDarkGrey,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['label'] != '' ? item['label'] : item['image_name'],
                    style: const TextStyle(
                      color: MyTheme.colorDarkGrey,
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
                        Navigator.pushNamed(context, AppRoute.detail,
                            arguments: item);
                      },
                      child: item['type'] == 'video'
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.play_arrow_rounded,
                                  color: MyTheme.colorDarkPurple,
                                  size: 42,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                      ),
                                      color: MyTheme.colorCyan,
                                    ),
                                    child: const Text(
                                      '02:32',
                                      style: TextStyle(
                                        color: MyTheme.colorDarkPurple,
                                        fontSize: 12,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 18.0,
                                            color: Colors.black54,
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        placeholder: (context, url) => Shimmer.fromColors(
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

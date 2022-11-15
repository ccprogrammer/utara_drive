import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({super.key, this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, provider, _) {
        return CachedNetworkImage(
          imageUrl: data['image_url'],
          imageBuilder: (context, imageProvider) => Hero(
            tag: data is QueryDocumentSnapshot ? data.id : data['id'],
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  image: imageProvider,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.detail,
                        arguments: data);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Icon(
                            data['type'] == 'image'
                                ? Icons.image
                                : Icons.play_arrow,
                            color: MyTheme.colorGrey,
                            size: 18,
                          ),
                          if (data['type'] == 'video')
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              child: const Text(
                                '02:42',
                                style: TextStyle(
                                  color: MyTheme.colorGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[300]!,
            child: const Skeleton(),
          ),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error)),
        );
      },
    );
  }
}

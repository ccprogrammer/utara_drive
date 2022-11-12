
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class ImageGrid extends StatelessWidget {
  const ImageGrid({super.key, this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, provider, _) {
        return CachedNetworkImage(
          imageUrl: data['image_url'],
          imageBuilder: (context, imageProvider) => Container(
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

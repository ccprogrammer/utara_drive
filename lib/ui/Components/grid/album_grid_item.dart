
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class AlbumGridItem extends StatelessWidget {
  const AlbumGridItem({super.key, this.item});
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: item['display_image'] ??
          'https://webcolours.ca/wp-content/uploads/2020/10/webcolours-unknown.png',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              offset: Offset(5, 7),
              spreadRadius: -6,
              blurRadius: 10,
              color: Colors.black38,
            )
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            image: imageProvider,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoute.detailAlbum,
                arguments: item,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  item['label'],
                  style: const TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 18.0,
                        color: Colors.black,
                        offset: Offset(4.0, 3.0),
                      ),
                    ],
                    color: MyTheme.colorWhite,
                    fontSize: 16,
                    fontWeight: MyTheme.semiBold,
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
        child: const Skeleton(radius: 12),
      ),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, this.data});
  final dynamic data;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final item = widget.data;

    return Scaffold(
      appBar: appBar(),
      body: Consumer<GalleryProvider>(
        builder: (context, provider, _) {
          return CachedNetworkImage(
            imageUrl: item['image_url'],
            imageBuilder: (context, imageProvider) => PhotoView(
              backgroundDecoration:
                  const BoxDecoration(color: MyTheme.colorWhite),
              imageProvider: imageProvider,
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
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: MyTheme.colorWhite,
      elevation: 0,
      title: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(backgroundColor: MyTheme.colorWhite),
        child: const Text(
          'Back',
          style: TextStyle(
            color: MyTheme.colorCyan,
          ),
        ),
      ),
    );
  }
}

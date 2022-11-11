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
  PhotoViewScaleStateController scaleController =
      PhotoViewScaleStateController();
  PhotoViewController controller = PhotoViewController();

  bool scaleAble = true;
  bool seeDetail = false;

  @override
  void initState() {
    super.initState();
    // controller.addIgnorableListener(() {
    //   var width = MediaQuery.of(context).size.width / 1000;
    //   double? scale = controller.scale;
    //   if (scale != null && scale < width) {
    //     setState(() {
    //       controller.scale = controller.initial.scale;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      bottomNavigationBar: BottomAppBar(
        color: MyTheme.colorWhite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_to_photos),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  seeDetail = !seeDetail;
                });
              },
              icon: Icon(
                  seeDetail ? Icons.arrow_circle_down : Icons.arrow_circle_up),
            ),
          ],
        ),
      ),
      body: Consumer<GalleryProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              CachedNetworkImage(
                imageUrl: item['image_url'],
                imageBuilder: (context, imageProvider) => PhotoView(
                  customSize: MediaQuery.of(context).size,
                  minScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.covered * 1.8,
                  basePosition: Alignment.center,
                  scaleStateChangedCallback: (value) {},
                  controller: controller,
                  scaleStateController: scaleController,
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
              ),
              seeDetail
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        color: MyTheme.colorWhite.withOpacity(0.3),
                      ),
                    )
                  : const SizedBox(),
            ],
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

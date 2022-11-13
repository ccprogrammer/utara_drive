import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:utara_drive/themes/my_themes.dart';

class ImageFullScreen extends StatefulWidget {
  const ImageFullScreen({super.key, this.data, this.fileImage = true});
  final dynamic data;
  final bool fileImage;

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  PhotoViewScaleStateController scaleController =
      PhotoViewScaleStateController();
  PhotoViewController controller = PhotoViewController();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Stack(
        children: [
          Hero(
            tag: 'add_image',
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 1.8,
              basePosition: Alignment.center,
              customSize: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size
                  : null,
              scaleStateChangedCallback: (value) {},
              controller: controller,
              scaleStateController: scaleController,
              backgroundDecoration:
                  const BoxDecoration(color: MyTheme.colorWhite),
              imageProvider: widget.fileImage
                  ? FileImage(widget.data)
                  : NetworkImage(widget.data) as ImageProvider<Object>?,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyTheme.colorDarkerGrey,
                ),
                child: const Icon(
                  Icons.fullscreen_exit,
                  color: MyTheme.colorWhite,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

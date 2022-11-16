import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GalleryGridVideoItem extends StatefulWidget {
  const GalleryGridVideoItem({super.key, this.data});
  final dynamic data;

  @override
  State<GalleryGridVideoItem> createState() => _GalleryGridVideoItemState();
}

class _GalleryGridVideoItemState extends State<GalleryGridVideoItem> {
  String? fileName = '';

  generateThumbnail() async {
    fileName = await VideoThumbnail.thumbnailFile(
      video:
          widget.data,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    generateThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, provider, _) {
        if (fileName != '') {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                image: FileImage(File(fileName!)),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.slow_motion_video_rounded,
                          color: MyTheme.colorGrey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
         
          );
        }

        return Shimmer.fromColors(
          baseColor: Colors.grey[500]!,
          highlightColor: Colors.grey[300]!,
          child: const Skeleton(),
        );
      },
    );
  }
}

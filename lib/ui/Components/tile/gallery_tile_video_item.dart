import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';
import 'package:utara_drive/ui/screen/detail_screen/video_detail_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GalleryTileVideoItem extends StatefulWidget {
  const GalleryTileVideoItem({super.key, this.item});
  final dynamic item;

  @override
  State<GalleryTileVideoItem> createState() => _GalleryTileVideoItemState();
}

class _GalleryTileVideoItemState extends State<GalleryTileVideoItem> {
  String? fileName = '';

  generateThumbnail() async {
    fileName = await VideoThumbnail.thumbnailFile(
      video: widget.item['file_url'],
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
    dynamic item = widget.item;
    if (fileName != '') {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.slow_motion_video_rounded,
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
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              height: 150,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  image: FileImage(File(fileName!)),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoDetailScreen(data: widget.item),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
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
    );
  }
}

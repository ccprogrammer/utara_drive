import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/add_gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/custom_text_field2.dart';
import 'dart:io';

import 'package:utara_drive/ui/Components/loading_fallback.dart';
import 'package:utara_drive/ui/screen/image_full_screen/image_full_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({
    super.key,
    required this.imageType,
    required this.image,
  });
  final XFile image;
  final String imageType;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late final Uint8List? fileName;

  generateThumbnail() async {
    if (widget.imageType == 'video') {
      fileName = await VideoThumbnail.thumbnailData(
        video: widget.image.path,
        imageFormat: ImageFormat.JPEG,
      );

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    generateThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingFallback(
      isLoading: Provider.of<AddGalleryProvider>(context).isLoading,
      child: Scaffold(
        backgroundColor: MyTheme.colorDarkPurple,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    dynamic file;

    if (widget.imageType == 'image') {
      file = File(widget.image.path);
    } else if (widget.imageType == 'video') {
      file = fileName;
    }

    return Consumer<AddGalleryProvider>(
      builder: (context, provider, _) {
        return ListView(
          children: [
            buildFile(file),
            const SizedBox(height: 24),
            CustomTextField2(
              hint: 'Add label',
              controller: provider.labelC,
            ),
            CustomTextField2(
              hint: 'Write a description',
              controller: provider.descriptionC,
              maxLines: null,
            ),
            CustomTextField2(
              hint: 'Add location',
              controller: provider.locationC,
              inputAction: TextInputAction.next,
            ),
            if (provider.tagList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
                child: Wrap(
                  spacing: 16,
                  children: [
                    for (var tag in provider.tagList)
                      Container(
                        padding: const EdgeInsets.fromLTRB(4, 6, 12, 6),
                        margin: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: MyTheme.colorGrey,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => provider.deleteTag(tag),
                              child: Icon(
                                Icons.close,
                                color: MyTheme.colorRed.withOpacity(0.6),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12,
                                color: MyTheme.colorBlack.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            CustomTextField2(
              hint: 'Add tag',
              controller: provider.tagC,
              inputAction: TextInputAction.done,
              onEditingComplete: (tag) => provider.addTag(),
            ),
          ],
        );
      },
    );
  }

  Widget buildFile(file) {
    // loading file name if file is video
    if (file is Uint8List && fileName == null) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                color: MyTheme.colorCyan,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Loading',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MyTheme.colorGrey,
              ),
            ),
          ],
        ),
      );
    }
    return Stack(
      children: [
        Hero(
          tag: 'add_image',
          child: file is File
              ? Image.file(
                  file,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )
              : Image.memory(
                  file,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
        ),

        // if image
        if (file is File)
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageFullScreen(data: file),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyTheme.colorDarkerGrey,
                ),
                child: const Icon(
                  Icons.fullscreen,
                  color: MyTheme.colorGrey,
                  size: 16,
                ),
              ),
            ),
          ),

        //  if video
        if (file is Uint8List)
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => VideoDetailScreen(data: file),
                  //   ),
                  // );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyTheme.colorDarkerGrey,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: MyTheme.colorGrey,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyTheme.colorBlueGrey,
      elevation: 0,
      iconTheme: const IconThemeData(color: MyTheme.colorGrey),
      title: const Text(
        'New Image',
        style: TextStyle(
          color: MyTheme.colorGrey,
        ),
      ),
      actions: [
        Consumer<AddGalleryProvider>(
          builder: (context, provider, _) {
            return IconButton(
              onPressed: () {
                provider.addGallery(context, widget.image, widget.imageType);
              },
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.check,
              ),
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

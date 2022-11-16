import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/providers/edit_gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/custom_text_field2.dart';

import 'package:utara_drive/ui/Components/loading_fallback.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';
import 'package:utara_drive/ui/screen/image_full_screen/image_full_screen.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    super.key,
    required this.data,
  });
  final dynamic data;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return LoadingFallback(
      isLoading: false,
      child: Scaffold(
        backgroundColor: MyTheme.colorDarkPurple,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<EditGalleryProvider>(
      builder: (context, provider, _) {
        return ListView(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                    imageUrl: widget.data['file_url'],
                    placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[500]!,
                          highlightColor: Colors.grey[300]!,
                          child: const Skeleton(
                            height: 250,
                            width: double.infinity,
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                    imageBuilder: (context, imageProvider) {
                      return Hero(
                        tag: 'add_image',
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              image: imageProvider,
                            ),
                          ),
                        ),
                      );
                    }),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageFullScreen(
                            data: widget.data['file_url'],
                            fileImage: false,
                          ),
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
                        color: MyTheme.colorDarkPurple,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
            // if (provider.tagList.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
            //     child: Wrap(
            //       spacing: 16,
            //       children: [
            //         for (var tag in provider.tagList)
            //           Container(
            //             padding: const EdgeInsets.fromLTRB(4, 6, 12, 6),
            //             margin: const EdgeInsets.only(top: 12),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(24),
            //               color: MyTheme.colorGrey,
            //             ),
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 GestureDetector(
            //                   onTap: () => provider.deleteTag(tag),
            //                   child: Icon(
            //                     Icons.close,
            //                     color: MyTheme.colorRed.withOpacity(0.6),
            //                     size: 16,
            //                   ),
            //                 ),
            //                 const SizedBox(width: 4),
            //                 Text(
            //                   tag,
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     color: MyTheme.colorBlack.withOpacity(0.6),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //       ],
            //     ),
            //   ),

            // CustomTextField2(
            //   hint: 'Add tag',
            //   controller: provider.tagC,
            //   inputAction: TextInputAction.done,
            //   onEditingComplete: (tag) => provider.addTag(),
            // ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyTheme.colorBlueGrey,
      elevation: 0,
      iconTheme: const IconThemeData(color: MyTheme.colorGrey),
      title: const Text(
        'Edit Gallery',
        style: TextStyle(
          color: MyTheme.colorGrey,
        ),
      ),
      actions: [
        Consumer<EditGalleryProvider>(
          builder: (context, provider, _) {
            return IconButton(
              onPressed: () {
                provider.editGallery(context, widget.data);
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

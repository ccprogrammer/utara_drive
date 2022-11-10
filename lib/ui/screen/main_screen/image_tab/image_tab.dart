import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/image_grid.dart';
import 'package:utara_drive/ui/Components/loading_fallback.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
  @override
  Widget build(BuildContext context) {
    User user = Helper().getUser();
    return LoadingFallback(
      isLoading: false,
      loadingLabel: 'Loading',
      child: Scaffold(
        backgroundColor: MyTheme.colorWhite,
        body: Consumer<GalleryProvider>(builder: (context, provider, _) {
          return StreamBuilder(
            stream: provider.getGallery(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                reverse: true,
                itemCount: data?.docs.length,
                itemBuilder: (context, index) {
                  var item = data?.docs[index];

                  return ImageGrid(data: item);
                },
              );
            },
          );
        }),
      ),
    );
  }
}

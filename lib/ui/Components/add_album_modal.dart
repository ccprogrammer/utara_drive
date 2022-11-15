import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/add_album_provider.dart';
import 'package:utara_drive/providers/album_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class AddAlbumModal extends StatefulWidget {
  const AddAlbumModal({super.key, this.gallery});
  final dynamic gallery;

  @override
  State<AddAlbumModal> createState() => _AddAlbumModalState();
}

class _AddAlbumModalState extends State<AddAlbumModal> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumProvider>(
      builder: (context, provider, _) {
        return Consumer<AddAlbumProvider>(builder: (context, addAlbum, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sheet Title
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: const Text(
                    'Save to',
                    style: TextStyle(
                      color: MyTheme.colorGrey,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // create new album if no album
                    if (provider.albumsList.isEmpty)
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 1,
                            color: MyTheme.colorDarkGrey,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Helper(ctx: context)
                                .showAlbumDialog(context: context);
                          },
                          child: const Icon(
                            Icons.add,
                            color: MyTheme.colorDarkGrey,
                          ),
                        ),
                      ),

                    Row(
                      children: provider.albumsList.map((item) {
                        bool isSaved = false;

                        String docId = widget.gallery is QueryDocumentSnapshot
                            ? widget.gallery.id
                            : widget.gallery['id'];
                        for (var gallery in item['gallery']) {
                          if (gallery['id'] == docId) {
                            isSaved = true;
                          }
                        }
                        return Container(
                          margin: EdgeInsets.only(
                              left: provider.albumsList.indexOf(item) == 0
                                  ? 16
                                  : 0,
                              right: 16),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: item['display_image'] ??
                                    'https://webcolours.ca/wp-content/uploads/2020/10/webcolours-unknown.png',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 82,
                                  height: 82,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      image: imageProvider,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Material(
                                    color: isSaved
                                        ? Colors.black38
                                        : Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        isSaved
                                            ? Helper(ctx: context).showNotif(
                                                title: 'Hello,',
                                                message:
                                                    'Image already in the album, remove feature is still not available',
                                                color: MyTheme.colorCyan,
                                              )
                                            : addAlbum.addToAlbum(
                                                context,
                                                item,
                                                widget.gallery,
                                              );
                                      },
                                      child: isSaved
                                          ? const Center(
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 42,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[500]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: const Skeleton(
                                    radius: 12,
                                    width: 82,
                                    height: 82,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['label'],
                                style: const TextStyle(
                                  color: MyTheme.colorGrey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: MyTheme.colorGrey),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

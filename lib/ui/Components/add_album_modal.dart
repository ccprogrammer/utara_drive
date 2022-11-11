import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 26,
              color: MyTheme.colorGrey,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),

                  // album modal component
                  for (var item in provider.albumsList)
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: item['display_image'] ??
                                'https://webcolours.ca/wp-content/uploads/2020/10/webcolours-unknown.png',
                            imageBuilder: (context, imageProvider) => Container(
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
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // log('ITEM === ${item.documentID}');
                                    Provider.of<AddAlbumProvider>(context,
                                            listen: false)
                                        .addToAlbum(
                                            context, item, widget.gallery)
                                        .then(
                                          (value) => Provider.of<AlbumProvider>(
                                                  context,
                                                  listen: false)
                                              .getAlbum(),
                                        );
                                  },
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
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
                          const SizedBox(height: 8),
                          Text(
                            item['label'],
                            style: const TextStyle(
                              color: MyTheme.colorBlack,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const Divider(
              thickness: 1,
              height: 26,
              color: MyTheme.colorGrey,
            ),

            TextButton(
              onPressed: () {},
              child: const Text(
                'Cancel',
                style: TextStyle(color: MyTheme.colorBlack),
              ),
            ),
          ],
        );
      },
    );
  }
}

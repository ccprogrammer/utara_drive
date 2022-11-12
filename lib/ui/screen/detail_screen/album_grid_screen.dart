import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/album_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/image_grid_item.dart';

class AlbumGridScreen extends StatefulWidget {
  const AlbumGridScreen({super.key, this.data});
  final dynamic data;

  @override
  State<AlbumGridScreen> createState() => _AlbumGridScreenState();
}

class _AlbumGridScreenState extends State<AlbumGridScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.colorWhite,
      appBar: appBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Consumer<AlbumProvider>(
      builder: (context, provider, _) {
        // select album from provider album list where selected album QuerySnapshot id from previous screen equal to album id in provider
        dynamic albums = provider.albumsList
            .where((element) => element.id == widget.data.id)
            .toList()[0];

        List galleryList = albums['gallery'];

        return GridView.custom(
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.mirrored,
            pattern: [
              const QuiltedGridTile(2, 2),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(2, 2),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            childCount: galleryList.length,
            (context, index) {
              var item = albums['gallery'][index];
              return ImageGridItem(data: item);
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget appBar() {
    final item = widget.data;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: MyTheme.colorWhite,
      toolbarHeight: 80,
      elevation: 0,
      title: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: MyTheme.colorWhite),
            child: const Text(
              'Back',
              style: TextStyle(
                color: MyTheme.colorCyan,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            item['label'],
            style: const TextStyle(
              color: MyTheme.colorCyan,
              fontSize: 20,
              fontWeight: MyTheme.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}

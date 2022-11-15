import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utara_drive/providers/album_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/album_grid_item.dart';

class AlbumTab extends StatefulWidget {
  const AlbumTab({super.key});

  @override
  State<AlbumTab> createState() => _AlbumTabState();
}

class _AlbumTabState extends State<AlbumTab> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final ScrollController scrollController = ScrollController();

  // refresher
  onRefresh() async {
    // monitor network fetch
    await Provider.of<AlbumProvider>(context, listen: false).getAlbum();
    refreshController.refreshCompleted();
  }

  onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: MyTheme.colorDarkPurple,
        body: SafeArea(
          child: SmartRefresher(
            controller: refreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
            header: const TwoLevelHeader(
              decoration: BoxDecoration(color: MyTheme.colorDarkPurple),
              textStyle: TextStyle(color: MyTheme.colorCyan),
              refreshingText: '',
              refreshingIcon: SizedBox(
                height: 24,
                width: 24,
              ),
              idleIcon: Icon(
                Icons.refresh,
                color: MyTheme.colorCyan,
              ),
              completeIcon: Icon(
                Icons.check,
                color: MyTheme.colorCyan,
              ),
              releaseIcon: Icon(
                Icons.arrow_upward,
                color: MyTheme.colorCyan,
              ),
            ),
            child: buildContent(),
          ),
        ),
      );
    });
  }

  buildContent() {
    return Consumer<AlbumProvider>(
      builder: (context, provider, _) {
        // on loading
        if (provider.isLoading) {
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

        // if albums empty
        if (provider.albumsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.hide_image_outlined,
                  size: 78,
                  color: MyTheme.colorCyan,
                ),
                SizedBox(height: 16),
                Text(
                  'Albums Empty',
                  style: TextStyle(
                    color: MyTheme.colorDarkerGrey,
                    fontSize: 24,
                  ),
                )
              ],
            ),
          );
        }

        // if albums not empty
        return GridView.custom(
          padding: const EdgeInsets.all(16),
          controller: scrollController,
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            repeatPattern: QuiltedGridRepeatPattern.mirrored,
            pattern: [
              const QuiltedGridTile(2, 2),
              const QuiltedGridTile(2, 2),
              const QuiltedGridTile(2, 2),
              const QuiltedGridTile(2, 2),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            childCount: provider.albumsList.length,
            (context, index) {
              var item = provider.albumsList[index];
              return AlbumGridItem(item: item);
            },
          ),
        );
      },
    );
  }
}

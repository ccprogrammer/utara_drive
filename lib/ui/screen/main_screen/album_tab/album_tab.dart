import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utara_drive/providers/album_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/album_grid.dart';

class AlbumTab extends StatefulWidget {
  const AlbumTab({super.key});

  @override
  State<AlbumTab> createState() => _AlbumTabState();
}

class _AlbumTabState extends State<AlbumTab> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

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
        backgroundColor: MyTheme.colorWhite,
        body: SafeArea(
          child: SmartRefresher(
            controller: refreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
            header: const TwoLevelHeader(
              decoration: BoxDecoration(color: MyTheme.colorCyan),
              textStyle: TextStyle(color: MyTheme.colorWhite),
              refreshingIcon: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: MyTheme.colorWhite,
                  strokeWidth: 3,
                ),
              ),
              idleIcon: Icon(
                Icons.refresh,
                color: MyTheme.colorWhite,
              ),
              completeIcon: Icon(
                Icons.check,
                color: MyTheme.colorWhite,
              ),
              releaseIcon: Icon(
                Icons.arrow_upward,
                color: MyTheme.colorWhite,
              ),
            ),
            child: GridView.custom(
              padding: const EdgeInsets.all(16),
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
                  return AlbumGrid(item: item);
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

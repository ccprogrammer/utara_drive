import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/gallery_grid.dart';
import 'package:utara_drive/ui/Components/list/gallery_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  bool isGrid = true;

  // refresher
  onRefresh() async {
    // monitor network fetch
    await Provider.of<GalleryProvider>(context, listen: false).getGallery();
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
    return Consumer<GalleryProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: MyTheme.colorWhite,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          isGrid = true;
                        }),
                        child: Icon(
                          Icons.grid_view_rounded,
                          color: isGrid
                              ? MyTheme.colorDarkerGrey
                              : MyTheme.colorDarkGrey,
                          size: 18,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        isGrid = false;
                      }),
                      child: Icon(
                        Icons.list_rounded,
                        color: isGrid
                            ? MyTheme.colorDarkGrey
                            : MyTheme.colorDarkerGrey,
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SmartRefresher(
                  controller: refreshController,
                  onRefresh: onRefresh,
                  onLoading: onLoading,
                  header: const TwoLevelHeader(
                    decoration: BoxDecoration(color: MyTheme.colorWhite),
                    textStyle: TextStyle(color: MyTheme.colorCyan),
                    refreshingIcon: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: MyTheme.colorCyan,
                        strokeWidth: 3,
                      ),
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
                  child: isGrid
                      ? galleryGridItem(provider.galleryList)
                      : galleryTile(provider.galleryList),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Widget galleryGridItem(List galleryList) {
  //   return GridView.custom(
  //     shrinkWrap: true,
  //     gridDelegate: SliverQuiltedGridDelegate(
  //       crossAxisCount: 4,
  //       mainAxisSpacing: 4,
  //       crossAxisSpacing: 4,
  //       repeatPattern: QuiltedGridRepeatPattern.mirrored,
  //       pattern: [
  //         const QuiltedGridTile(2, 2),
  //         const QuiltedGridTile(1, 1),
  //         const QuiltedGridTile(1, 1),
  //         const QuiltedGridTile(1, 1),
  //         const QuiltedGridTile(1, 1),
  //         const QuiltedGridTile(1, 1),
  //         const QuiltedGridTile(1, 1),
  //         const QuiltedGridTile(2, 2),
  //         const QuiltedGridTile(1, 1),
  //         const QuiltedGridTile(1, 1),
  //       ],
  //     ),
  //     childrenDelegate: SliverChildBuilderDelegate(
  //       childCount: galleryList.length,
  //       (context, index) {
  //         dynamic item = galleryList
  //             .where((element) => element.id == galleryList[index].id)
  //             .toList()[0];

  //         return GalleryGridItem(data: item);
  //       },
  //     ),
  //   );
  // }
}

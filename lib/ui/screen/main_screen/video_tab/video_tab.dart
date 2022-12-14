import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/gallery_grid_image_item.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({super.key});

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

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
        backgroundColor: MyTheme.colorDarkPurple,
        body: SafeArea(
          child: SmartRefresher(
            controller: refreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
           header: const TwoLevelHeader(
              decoration: BoxDecoration(color: MyTheme.colorDarkPurple),
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
              child: GridView.custom(
              shrinkWrap: true,
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
                childCount: provider.videoList.length,
                (context, index) {
                  dynamic item = provider.videoList
                      .where((element) =>
                          element.id == provider.galleryList[index].id)
                      .toList()[0];
                      
                  return GalleryGridImageItem(data: item);
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

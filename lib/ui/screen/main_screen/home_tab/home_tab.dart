import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/gallery_grid.dart';
import 'package:utara_drive/ui/Components/list/gallery_tile.dart';
import 'package:utara_drive/ui/Components/switch_layout.dart';

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
              SwitchLayout(
                isGrid: isGrid,
                changeLayout: (value) => setState(() {
                  isGrid = value;
                }),
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
                  child: buildContent(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  buildContent() {
    return Consumer<GalleryProvider>(
      builder: (context, provider, _) {
        // on loading
        if (provider.isLoading && provider.galleryList.isEmpty) {
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
                      color: Colors.black),
                ),
              ],
            ),
          );
        }

        // if gallery empty
        if (provider.galleryList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 78,
                  color: MyTheme.colorDarkerGrey,
                ),
                SizedBox(height: 16),
                Text(
                  'Gallery Empty',
                  style: TextStyle(
                    color: MyTheme.colorDarkerGrey,
                    fontSize: 24,
                  ),
                )
              ],
            ),
          );
        }

        // if gallery not empty
        return isGrid
            ? galleryGridItem(provider.galleryList)
            : galleryTile(provider.galleryList);
      },
    );
  }
}

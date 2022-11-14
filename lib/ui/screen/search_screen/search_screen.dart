import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/gallery_grid_item.dart';
import 'package:utara_drive/ui/Components/search_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
      return WillPopScope(
        onWillPop: () async {
          provider.clearSearch();

          return true;
        },
        child: Scaffold(
          backgroundColor: MyTheme.colorWhite,
          appBar: searchAppBar(),
          body: SafeArea(
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
              child: buildBody(),
            ),
          ),
        ),
      );
    });
  }

  buildBody() {
    return Consumer<GalleryProvider>(
      builder: (context, provider, _) {
        // if search empty
        if (provider.searchC.text == '' && provider.searchList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.image_search,
                  size: 78,
                  color: MyTheme.colorDarkerGrey,
                ),
                SizedBox(height: 16),
                Text(
                  'Search Image',
                  style: TextStyle(
                    color: MyTheme.colorDarkerGrey,
                    fontSize: 24,
                  ),
                )
              ],
            ),
          );
        }

        // if search not found
        if (provider.searchC.text != '' && provider.searchList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.image_search,
                  size: 78,
                  color: MyTheme.colorDarkerGrey,
                ),
                SizedBox(height: 16),
                Text(
                  'Image not found',
                  style: TextStyle(
                    color: MyTheme.colorDarkerGrey,
                    fontSize: 24,
                  ),
                )
              ],
            ),
          );
        }

        // if search not empty
        return GridView.custom(
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
            childCount: provider.searchList.length,
            (context, index) {
              dynamic item = provider.searchList
                  .where(
                      (element) => element.id == provider.searchList[index].id)
                  .toList()[0];

              return GalleryGridItem(data: item);
            },
          ),
        );
      },
    );
  }
}

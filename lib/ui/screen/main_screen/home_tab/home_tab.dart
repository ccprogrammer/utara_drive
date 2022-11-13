import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/grid/image_grid_item.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  bool isGrid = false;

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
                      ? gridTile(provider.galleryList)
                      : listTile(provider.galleryList),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget gridTile(List galleryList) {
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
        childCount: galleryList.length,
        (context, index) {
          dynamic item = galleryList
              .where((element) => element.id == galleryList[index].id)
              .toList()[0];

          return ImageGridItem(data: item);
        },
      ),
    );
  }

  Widget listTile(List galleryList) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 42),
      itemCount: galleryList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        dynamic item = galleryList
            .where((element) => element.id == galleryList[index].id)
            .toList()[0];

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: CachedNetworkImage(
              imageUrl: item['image_url'],
              placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[500]!,
                    highlightColor: Colors.grey[300]!,
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Skeleton(
                              width: 20,
                              height: 18,
                              radius: 4,
                              marginRight: 8,
                            ),
                            Skeleton(
                              width: 130,
                              height: 18,
                              radius: 4,
                            )
                          ],
                        ),
                        const Skeleton(marginTop: 16),
                        const Skeleton(
                          height: 150,
                          radius: 16,
                        ),
                      ],
                    ),
                  ),
              errorWidget: (context, url, error) => Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            item['type'] == 'image'
                                ? Icons.image
                                : Icons.slow_motion_video_rounded,
                            color: MyTheme.colorDarkerGrey,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item['label'] != ''
                                ? item['label']
                                : item['image_name'],
                            style: const TextStyle(
                              color: MyTheme.colorDarkerGrey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: const Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ],
                  ),
              imageBuilder: (context, imageProvider) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          item['type'] == 'image'
                              ? Icons.image
                              : Icons.slow_motion_video_rounded,
                          color: MyTheme.colorDarkerGrey,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item['label'] != ''
                              ? item['label']
                              : item['image_name'],
                          style: const TextStyle(
                            color: MyTheme.colorDarkerGrey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: item['type'] == 'video'
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(
                                      Icons.play_arrow_rounded,
                                      color: MyTheme.colorWhite,
                                      size: 42,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16),
                                          ),
                                          color: MyTheme.colorCyan,
                                        ),
                                        child: const Text(
                                          '02:32',
                                          style: TextStyle(
                                            color: MyTheme.colorWhite,
                                            fontSize: 12,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 18.0,
                                                color: Colors.black54,
                                                offset: Offset(2.0, 2.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/switch_layout.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
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
        backgroundColor: MyTheme.colorDarkPurple,
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
                  child: const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/auth_provider.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/loading_fallback.dart';
import 'package:utara_drive/ui/screen/main_screen/album_tab/album_tab.dart';
import 'package:utara_drive/ui/screen/main_screen/home_tab/home_tab.dart';
import 'package:utara_drive/ui/screen/main_screen/image_tab/image_tab.dart';
import 'package:utara_drive/ui/screen/main_screen/video_tab/video_tab.dart';
import 'package:utara_drive/ui/screen/page_not_found.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  handleFab(String type) {
    switch (type) {
      case 'image':
        Helper(ctx: context).openGalleryPhoto(context);
        break;

      case 'video':
        Helper(ctx: context).openGalleryVideo(context);
        break;

      case 'photo':
        Helper(ctx: context).openCameraPhoto(context);
        break;

      case 'record':
        Helper(ctx: context).openCameraVideo(context);
        break;

      case 'album':
        Helper(ctx: context).showAlbumDialog(context: context);
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    // final loadingCreateAlbum = Provider.of<AddAlbumProvider>(context).isLoading;
    return LoadingFallback(
      isLoading: false,
      child: Scaffold(
        appBar: _appBar(),
        floatingActionButton: buildFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildNavBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget buildFab() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22.0),
      icon: Icons.add,
      overlayColor: Colors.white,
      activeIcon: Icons.close,
      spacing: 3,
      mini: false,
      backgroundColor: MyTheme.colorCyan,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      buttonSize: const Size(56, 56),
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      useRotationAnimation: true,
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      elevation: 2.0,
      animationCurve: Curves.elasticInOut,
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.add_to_photos,
            size: 24,
          ),
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          label: 'Create Album',
          onTap: () => handleFab('album'),
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.video_call_rounded,
            size: 26,
          ),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          label: 'Record video',
          visible: true,
          onTap: () => handleFab('record'),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_a_photo),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          label: 'Take a photo',
          onTap: () => handleFab('photo'),
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.video_collection_rounded,
            size: 26,
          ),
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          label: 'Add video',
          visible: true,
          onTap: () => handleFab('video'),
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.add_photo_alternate,
            size: 26,
          ),
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.white,
          label: 'Add image',
          visible: true,
          onTap: () => handleFab('image'),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: MyTheme.colorWhite,
      toolbarHeight: 80,
      elevation: 0,
      titleSpacing: 0,
      title: Consumer<AuthProvider>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.search);
                  },
                  child: Row(
                    children: [
                      // button search
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: MyTheme.colorCyan,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/icon_search.png',
                            width: 18,
                            height: 18,
                            color: MyTheme.colorWhite,
                          ),
                        ),
                      ),
                      // search field
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            border: Border.all(
                              width: 1,
                              color: MyTheme.colorGrey,
                            ),
                          ),
                          height: 48,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: MyTheme.colorDarkGrey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 24),

              // sign out button
              IconButton(
                onPressed: () {
                  provider.signOut(context);
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                iconSize: 24,
                icon: const Icon(Icons.logout),
                color: MyTheme.colorDarkerGrey,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNavBar() {
    return BottomNavigationBar(
      backgroundColor: MyTheme.colorWhite,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyTheme.colorCyan,
      unselectedItemColor: MyTheme.colorDarkerGrey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (value) => setState(() {
        if (value != 2) currentIndex = value;
      }),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.image_outlined),
          label: 'Image',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(),
          label: 'Empty',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ondemand_video),
          label: 'Video',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_library_outlined),
          label: 'Album',
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (currentIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return const ImageTab();
      case 2:
        // nothing to do here
        break;
      case 3:
        return const VideoTab();
      case 4:
        return const AlbumTab();
      default:
    }
    return const PageNotFound();
  }
}

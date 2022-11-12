import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
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
  bool _isShowDial = false;

  handleFab(String type) {
    switch (type) {
      case 'gallery':
        Helper(ctx: context).showImageDialog(context: context);
        break;

      case 'camera':
        Helper(ctx: context).showImageDialog(context: context, isCamera: true);
        break;

      // Navigator.pushNamed(context, AppRoute.search);
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
        backgroundColor: Colors.white,
        appBar: _appBar(),
        bottomNavigationBar: buildBottomNav(),
        body: _buildBody(),
      ),
    );
  }

  buildBottomNav() {
    return AnimatedBottomNavigationBar(
      bottomBarItems: [
        BottomBarItemsModel(
          icon: const Icon(Icons.home, size: 24),
          iconSelected:
              const Icon(Icons.home, color: AppColors.cherryRed, size: 24),
          title: 'Home',
          dotColor: Colors.pink,
          onTap: () => setState(() {
            currentIndex = 0;
          }),
        ),
        BottomBarItemsModel(
          icon: const Icon(Icons.image_outlined, size: 24),
          iconSelected:
              const Icon(Icons.image_outlined, color: AppColors.cherryRed, size: 24),
          title: 'Image',
          dotColor: Colors.pink,
          onTap: () => setState(() {
            currentIndex = 1;
          }),
        ),
        BottomBarItemsModel(
          icon: const Icon(Icons.ondemand_video, size: 24),
          iconSelected:
              const Icon(Icons.ondemand_video, color: AppColors.cherryRed, size: 24),
          title: 'Video',
          dotColor: Colors.pink,
          onTap: () => setState(() {
            currentIndex = 2;
          }),
        ),
        BottomBarItemsModel(
          icon: const Icon(Icons.photo_library_outlined, size: 24),
          iconSelected:
              const Icon(Icons.photo_library_outlined, color: AppColors.cherryRed, size: 24),
          title: 'Albums',
          dotColor: Colors.pink,
          onTap: () => setState(() {
            currentIndex = 3;
          }),
        ),
      ],
      bottomBarCenterModel: BottomBarCenterModel(
        centerBackgroundColor: Colors.pink,
        centerIcon: const FloatingCenterButton(
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
        centerIconChild: [
          FloatingCenterButtonChild(
            child: const Icon(
              Icons.home,
              color: AppColors.white,
            ),
            onTap: () {},
          ),
          FloatingCenterButtonChild(
            child: const Icon(
              Icons.home,
              color: AppColors.white,
            ),
            onTap: () {},
          ),
          FloatingCenterButtonChild(
            child: const Icon(
              Icons.home,
              color: AppColors.white,
            ),
            onTap: () {},
          ),
        ],
      ),
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
                color: MyTheme.colorCyan,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _getFloatingActionButton() {
    return SpeedDialMenuButton(
      //if needed to close the menu after clicking sub-FAB
      isShowSpeedDial: _isShowDial,
      //manually open or close menu
      updateSpeedDialStatus: (isShow) {
        //return any open or close change within the widget
        _isShowDial = isShow;
      },
      //general init
      isMainFABMini: false,

      isSpeedDialFABsMini: true,
      paddingBtwSpeedDialButton: 30.0,
      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
        mini: false,
        child: const Icon(
          Icons.menu,
          size: 28,
        ),
        onPressed: () {},
        backgroundColor: MyTheme.colorCyan,
        closeMenuChild: const Icon(
          Icons.close,
          size: 28,
        ),
        closeMenuForegroundColor: Colors.white,
        closeMenuBackgroundColor: MyTheme.colorRed,
      ),

      floatingActionButtonWidgetChildren: [
        FloatingActionButton(
          heroTag: 'album',
          mini: true,
          onPressed: () {
            handleFab('album');
            _isShowDial = false;
            setState(() {});
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.add_to_photos_rounded),
        ),
        FloatingActionButton(
          heroTag: 'camera',
          mini: true,
          onPressed: () {
            handleFab('camera');
            _isShowDial = false;
            setState(() {});
          },
          backgroundColor: Colors.pink,
          child: const Icon(Icons.add_a_photo),
        ),
        FloatingActionButton(
          heroTag: 'gallery',
          mini: true,
          onPressed: () {
            handleFab('gallery');
            _isShowDial = false;
            setState(() {});
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add_photo_alternate),
        ),
      ],
    );
  }

  Widget _buildNavBar() {
    return BottomNavigationBar(
      backgroundColor: MyTheme.colorCyan,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyTheme.colorWhite,
      unselectedItemColor: MyTheme.colorWhite.withOpacity(0.6),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (value) => setState(() {
        currentIndex = value;
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
        return const VideoTab();
      case 3:
        return const AlbumTab();
      default:
    }
    return const PageNotFound();
  }
}

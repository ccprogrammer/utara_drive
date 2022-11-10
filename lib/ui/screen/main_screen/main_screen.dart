import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';
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
        Helper(context: context).showImageDialog(context: context);

        break;
      case 'camera':
        Helper(context: context)
            .showImageDialog(context: context, isCamera: true);

        break;
      case 'search':
        Navigator.pushNamed(context, AppRoute.search);
        log('SEARCH !!!');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _getFloatingActionButton(),
      bottomNavigationBar: _buildNavBar(),
      body: _buildBody(),
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
          heroTag: 'search',
          mini: true,
          onPressed: () {
            handleFab('search');
            _isShowDial = false;
            setState(() {});
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.search),
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

import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/app_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyTheme.colorCyan,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: MyTheme.colorWhite,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
        items: navBarItem,
      ),
      body: _body(),
    );
  }

  List<BottomNavigationBarItem> navBarItem = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.image_outlined),
      label: 'Image',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_collection_outlined),
      label: 'Video',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.photo_library_outlined),
      label: 'Album',
    ),
  ];

  _body() {
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

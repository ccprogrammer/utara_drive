import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utara_drive/ui/screen/detail_screen/album_detail_screen.dart';
import 'package:utara_drive/ui/screen/detail_screen/gallery_detail_screen.dart';
import 'package:utara_drive/ui/screen/detail_screen/video_detail_screen.dart';
import 'package:utara_drive/ui/screen/edit_screen.dart/edit_screen.dart';
import 'package:utara_drive/ui/screen/main_screen/home_tab/home_tab.dart';
import 'package:utara_drive/ui/screen/initial_screen.dart';
import 'package:utara_drive/ui/screen/auth_screen/auth_screen.dart';
import 'package:utara_drive/ui/screen/main_screen/main_screen.dart';
import 'package:utara_drive/ui/screen/page_not_found.dart';
import 'package:utara_drive/ui/screen/search_screen/search_screen.dart';

abstract class AppRoute {
  static const pageNotFound = '/';
  static const initial = '/initial';
  static const auth = '/auth';
  static const mainScreen = '/main-screen';
  static const home = '/home';
  static const add = '/add';
  static const search = '/search';
  static const detailImage = '/detail-image';
  static const detailVideo = '/detail-video';
  static const edit = '/edit';
  static const detailAlbum = '/detail-album';
}

class GetRoute {
  static final routes = {
    AppRoute.pageNotFound: (BuildContext context) => const PageNotFound(),
    AppRoute.auth: (BuildContext context) => const AuthScreen(),
  };

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.initial:
        return CupertinoPageRoute(builder: (context) => const InitialScreen());

      case AppRoute.mainScreen:
        return CupertinoPageRoute(builder: (context) => const MainScreen());

      case AppRoute.home:
        return CupertinoPageRoute(builder: (context) => const HomeTab());

      case AppRoute.edit:
        return CupertinoPageRoute(
            builder: (context) => EditScreen(data: settings.arguments));

      case AppRoute.search:
        return CupertinoPageRoute(builder: (context) => const SearchScreen());

      case AppRoute.detailImage:
        return MaterialPageRoute(
            builder: (context) =>
                GalleryDetailScreen(data: settings.arguments));

      case AppRoute.detailVideo:
        return MaterialPageRoute(
            builder: (context) => VideoDetailScreen(data: settings.arguments));

      case AppRoute.detailAlbum:
        return CupertinoPageRoute(
            builder: (context) => AlbumDetailScreen(data: settings.arguments));

      default:
        return CupertinoPageRoute(
          builder: (context) => const PageNotFound(),
        );
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:utara_drive/ui/screen/detail_screen/album_detail_screen.dart';
import 'package:utara_drive/ui/screen/detail_screen/detail_screen.dart';
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
  static const detail = '/detail';
  static const detailAlbum = '/detail-album';
}

class GetRoute {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.pageNotFound:
        return CupertinoPageRoute(builder: (context) => const PageNotFound());

      case AppRoute.initial:
        return CupertinoPageRoute(builder: (context) => const InitialScreen());

      case AppRoute.mainScreen:
        return CupertinoPageRoute(builder: (context) => const MainScreen());

      case AppRoute.home:
        return CupertinoPageRoute(builder: (context) => const HomeTab());

      case AppRoute.auth:
        return CupertinoPageRoute(builder: (context) => const AuthScreen());

      case AppRoute.search:
        return CupertinoPageRoute(builder: (context) => const SearchScreen());

      case AppRoute.detail:
        return CupertinoPageRoute(
            builder: (context) => DetailScreen(data: settings.arguments));

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

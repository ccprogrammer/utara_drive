import 'package:flutter/cupertino.dart';
import 'package:utara_drive/ui/screen/add_screen/add_screen.dart';
import 'package:utara_drive/ui/screen/main_screen/home_tab/home_tab.dart';
import 'package:utara_drive/ui/screen/initial_screen.dart';
import 'package:utara_drive/ui/screen/auth_screen/auth_screen.dart';
import 'package:utara_drive/ui/screen/main_screen/main_screen.dart';
import 'package:utara_drive/ui/screen/page_not_found.dart';

abstract class AppRoute {
  static const pageNotFound = '/';
  static const initial = '/initial';
  static const auth = '/auth';
  static const mainScreen = '/main-screen';
  static const home = '/home';
  static const add = '/add';
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

      case AppRoute.add:
        return CupertinoPageRoute(builder: (context) => const AddScreen());

      default:
        return CupertinoPageRoute(
          builder: (context) => const PageNotFound(),
        );
    }
  }
}

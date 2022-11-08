import 'package:flutter/cupertino.dart';
import 'package:utara_drive/ui/screen/home_screen/home_screen.dart';
import 'package:utara_drive/ui/screen/initial_screen.dart';
import 'package:utara_drive/ui/screen/auth_screen/auth_screen.dart';
import 'package:utara_drive/ui/screen/page_not_found.dart';

abstract class AppRoute {
  static const pageNotFound = '/';
  static const initial = '/initial';
  static const register = '/register';
  static const auth = '/auth';
  static const home = '/home';
}

class GetRoute {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.pageNotFound:
        return CupertinoPageRoute(builder: (context) => const PageNotFound());

      case AppRoute.initial:
        return CupertinoPageRoute(builder: (context) => const InitialScreen());

      case AppRoute.home:
        return CupertinoPageRoute(builder: (context) => const HomeScreen());

      case AppRoute.auth:
        return CupertinoPageRoute(builder: (context) => const AuthScreen());

      default:
        return CupertinoPageRoute(
          builder: (context) => const PageNotFound(),
        );
    }
  }
}

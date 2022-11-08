import 'package:flutter/cupertino.dart';
import 'package:utara_drive/ui/screen/home_screen/home_screen.dart';
import 'package:utara_drive/ui/screen/initial_screen.dart';
import 'package:utara_drive/ui/screen/login_screen/login_screen.dart';
import 'package:utara_drive/ui/screen/page_not_found.dart';

abstract class AppRoute {
  static const pageNotFound = '/';
  static const initial = '/initial';
  static const register = '/register';
  static const login = '/login';
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

      case AppRoute.login:
        return CupertinoPageRoute(builder: (context) => const LoginScreen());

      default:
        return CupertinoPageRoute(
          builder: (context) => const PageNotFound(),
        );
    }
  }
}

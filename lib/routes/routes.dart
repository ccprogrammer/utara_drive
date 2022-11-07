import 'package:flutter/material.dart';
import 'package:utara_drive/ui/screen/initial_screen.dart';
import 'package:utara_drive/ui/screen/no_screen.dart';

abstract class AppRoute {
  static const noScreen = '/';
  static const initial = '/initial';
  static const register = '/register';
  static const login = '/login';
  static const home = '/home';
}

class GetRoute {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.noScreen:
        return MaterialPageRoute(builder: (context) => const NoScreen());

      case AppRoute.initial:
        return MaterialPageRoute(builder: (context) => const InitialScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => const InitialScreen(),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: MyTheme.colorWhite,
      body: Center(
        child: Text('Home Tab'),
      ),
    );
  }
}

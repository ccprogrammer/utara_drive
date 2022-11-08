import 'package:flutter/material.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 2200),
      () => Navigator.pushNamed(context, AppRoute.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/image_splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/image_logo.png',
                width: 140,
                height: 140,
              ),
            ),
            const Text(
              'Welcome to',
              style: TextStyle(
                color: MyTheme.colorWhite,
                fontSize: 32,
              ),
            ),
            const Text(
              'uDrive',
              style: TextStyle(
                color: MyTheme.colorWhite,
                fontSize: 72,
                fontStyle: FontStyle.italic,
                fontWeight: MyTheme.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

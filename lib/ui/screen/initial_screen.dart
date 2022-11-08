import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/auth_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  authState() async {
    Future.delayed(
      const Duration(milliseconds: 1200),
      () async => await Provider.of<AuthProvider>(context, listen: false)
          .authState(context),
    );
  }

  @override
  void initState() {
    super.initState();
    authState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/image_splash.png"),
            //   fit: BoxFit.cover,
            // ),
            gradient: LinearGradient(
          colors: [
            Color(0xff56CCF2),
            Color(0xff2F80ED),
          ],
        )),
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

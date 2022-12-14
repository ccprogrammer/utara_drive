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
  authState() {
    Future.delayed(
      const Duration(milliseconds: 1200),
      () =>
          Provider.of<AuthProvider>(context, listen: false).authState(context),
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
          color: MyTheme.colorDarkPurple,
        ),
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Hero(
            //   tag: 'logo',
            //   child: Image.asset(
            //     'assets/images/image_logo.png',
            //     width: 140,
            //     height: 140,
            //   ),
            // ),
            Text(
              'Welcome to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            Text(
              'uDrive',
              style: TextStyle(
                color: Colors.white,
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

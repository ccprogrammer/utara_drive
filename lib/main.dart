import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/firebase_options.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/add_album_provider.dart';
import 'package:utara_drive/providers/add_gallery_provider.dart';
import 'package:utara_drive/providers/album_provider.dart';
import 'package:utara_drive/providers/auth_provider.dart';
import 'package:utara_drive/providers/edit_gallery_provider.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: MyTheme.colorBlueGrey, // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> connectivityPlus =
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (ConnectivityResult.none == result) {
      Helper(ctx: context).showAlertDialog(
        context: context,
        icon: Icons.wifi_off_rounded,
        text: 'Please check your internet connection',
        titleLeft: 'Close',
        oneButton: true,
      );
    } else if (ConnectivityResult.mobile == result) {
    } else if (ConnectivityResult.wifi == result) {}
  });

  @override
  void dispose() {
    super.dispose();
    connectivityPlus.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddGalleryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GalleryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddAlbumProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AlbumProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditGalleryProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Nunito',
        ),
        initialRoute: AppRoute.initial,
        routes: GetRoute.routes,
        onGenerateRoute: GetRoute().generateRoute,
      ),
    );
  }
}

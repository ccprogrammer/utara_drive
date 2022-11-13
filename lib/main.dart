import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/firebase_options.dart';
import 'package:utara_drive/providers/add_album_provider.dart';
import 'package:utara_drive/providers/add_gallery_provider.dart';
import 'package:utara_drive/providers/album_provider.dart';
import 'package:utara_drive/providers/auth_provider.dart';
import 'package:utara_drive/providers/edit_gallery_provider.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/ui/screen/page_not_found.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   await FlutterDownloader.initialize(
    debug: true, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ),  ChangeNotifierProvider(
          create: (context) => EditGalleryProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoute.initial,
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (_) => const PageNotFound()),
        onGenerateRoute: GetRoute().generateRoute,
      ),
    );
  }
}

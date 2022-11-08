import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/auth_provider.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/ui/screen/page_not_found.dart';

void main()async {
  
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

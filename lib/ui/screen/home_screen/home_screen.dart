import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            child: const Text('Home Screen')),
      ),
    );
  }
}

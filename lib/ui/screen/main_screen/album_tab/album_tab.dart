import 'package:flutter/material.dart';

class AlbumTab extends StatefulWidget {
  const AlbumTab({super.key});

  @override
  State<AlbumTab> createState() => _AlbumTabState();
}

class _AlbumTabState extends State<AlbumTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Album Tab'),
      ),
    );
  }
}

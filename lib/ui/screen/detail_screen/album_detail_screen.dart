import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';

class AlbumDetailScreen extends StatefulWidget {
  const AlbumDetailScreen({super.key, this.data});
  final dynamic data;

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.colorWhite,
      appBar: appBar(),
      body: const Center(
        child: Text('Album Detail'),
      ),
    );
  }

  

  PreferredSizeWidget appBar() {
    final item = widget.data;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: MyTheme.colorWhite,
      toolbarHeight: 80,
      elevation: 0,
      title: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: MyTheme.colorWhite),
            child: const Text(
              'Back',
              style: TextStyle(
                color: MyTheme.colorCyan,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            item['label'],
            style: const TextStyle(
              color: MyTheme.colorCyan,
              fontSize: 24,
              fontWeight: MyTheme.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}

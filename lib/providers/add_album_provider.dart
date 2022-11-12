import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/album_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';

class AddAlbumProvider with ChangeNotifier {
  late User user = FirebaseAuth.instance.currentUser as User;

  bool isLoading = false;

  Future createAlbum(BuildContext context, String label) async {
    isLoading = true;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('albums')
        .doc()
        .set({
      'id': null,
      'label': label,
      'type': 'album',
      'created_at': Timestamp.now(),
      'display_image':
          'https://webcolours.ca/wp-content/uploads/2020/10/webcolours-unknown.png',
      'gallery': [],
    }).then((value) {
      Navigator.pop(context);
      Helper(ctx: context).showNotif(
        title: 'Success',
        message: 'Album created',
        color: MyTheme.colorCyan,
      );
      log("Album Added");

      Provider.of<AlbumProvider>(context, listen: false).getAlbum();
    }).catchError((error) {
      Helper(ctx: context).showNotif(
        title: 'Failed',
        message: 'Failed to create album',
      );
      log("Failed to create album: $error");
    });

    isLoading = false;
    notifyListeners();
  }

  Future addToAlbum(context, album, gallery) async {
    isLoading = true;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('albums')
        .doc(album.id)
        .update(
      {
        'gallery': [
          ...album['gallery'],
          {
            ...gallery.data(),
            'id': gallery.id,
          }
        ],
        'display_image': gallery['image_url'],
      },
    ).then((value) {
      Navigator.pop(context);
      Helper(ctx: context).showNotif(
        title: 'Success',
        message: 'Gallery added to album',
        color: MyTheme.colorCyan,
      );

      Provider.of<AlbumProvider>(context, listen: false).getAlbum();
    }).catchError((onError) {
      Helper(ctx: context).showNotif(
        title: 'Failed',
        message: 'Failed to add gallery',
      );
      isLoading = false;
      notifyListeners();
    });

    isLoading = false;
    notifyListeners();
  }
}

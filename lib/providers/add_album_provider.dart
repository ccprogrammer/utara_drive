import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/themes/my_themes.dart';

class AddAlbumProvider with ChangeNotifier {
  late User user = FirebaseAuth.instance.currentUser as User;

  bool isLoading = false;

  Future createAlbum(String label) async {
    isLoading = true;
    notifyListeners();

    var album = await FirebaseFirestore.instance
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
        })
        .then((value) => log("Album Added"))
        .catchError((error) => log("Failed to add Album: $error"));

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
          gallery.data(),
        ],
        'display_image': gallery['image_url'],
      },
    ).then((value) {
      Helper(ctx: context).showNotif(
        title: 'Success',
        message: 'Gallery added to album',
        color: MyTheme.colorCyan,
      );
      log("Album Updated");
    }).catchError((error) {
      Helper(ctx: context).showNotif(
        title: 'Failed',
        message: 'An error occurred, $error',
      );
      log("Failed to update album: $error");
    });

    isLoading = false;
    notifyListeners();
  }
}

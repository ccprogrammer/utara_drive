import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AddAlbumProvider with ChangeNotifier {
  late User user = FirebaseAuth.instance.currentUser as User;

  bool isLoading = false;

  Future createAlbum(String label) async {
    isLoading = true;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('albums')
        .doc()
        .set({
          'uid': user.uid,
          'label': label,
          'type': 'album',
          'created_at': Timestamp.now(),
          'date': DateTime.now(),
          'display_image': null,
          'gallery': [],
        })
        .then((value) => log("Album Added"))
        .catchError((error) => log("Failed to add Album: $error"));

    isLoading = false;
    notifyListeners();
  }
}

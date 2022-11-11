import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AlbumProvider with ChangeNotifier {
  late User user = FirebaseAuth.instance.currentUser as User;
  List albumsList = [];
  bool isLoading = false;

  initData() {
    getAlbum();
  }

  Future getAlbum() async {
    log('UID NIH === ${user.uid}');
    isLoading = true;
    notifyListeners();

    List tmpAlbums = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('albums')
        .orderBy('created_at', descending: true)
        // .where('type', isEqualTo: 'image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        tmpAlbums.add(doc);
      }
      albumsList = tmpAlbums;
      isLoading = false;

      log('Albums List === ${albumsList.length}');
      notifyListeners();
    }).onError(
      (error, stackTrace) {
        log('Failed to get gallery: $error');
      },
    );
  }
}

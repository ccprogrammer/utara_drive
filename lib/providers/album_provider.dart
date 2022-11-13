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
    isLoading = true;
    notifyListeners();

    List tmpAlbums = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('albums')
        .orderBy('created_at', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        tmpAlbums.add(doc);
      }
      albumsList = tmpAlbums;

      log('Albums List === ${albumsList.length}');
      isLoading = false;
      notifyListeners();
    }).catchError(
      (error) {
        log('Failed to get gallery: $error');
      },
    );
  }

  Future removeGalleryInAlbum(context, gallery) async {
    String docId =
        gallery is QueryDocumentSnapshot ? gallery.id : gallery['id'];

    // delete gallery from album
    for (var item in albumsList) {
      item['gallery'].removeWhere((element) => element['id'] == docId);
    }
    
  }
}

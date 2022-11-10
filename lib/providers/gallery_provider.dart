import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:utara_drive/helper/helper.dart';

class GalleryProvider with ChangeNotifier {
  List galleryList = [];

  bool isLoading = false;
  bool isLoadingMore = false;


  User user = Helper().getUser();

  Future getGallery() async {
    isLoading = true;
    isLoadingMore = true;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gallery')
        .where('type', isEqualTo: 'image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        galleryList.add(doc);
      }
      isLoading = false;
      isLoadingMore = true;

      log('Gallery List === ${galleryList.length}');
      notifyListeners();
    });
  }

  Stream getImage() {
    User user = Helper().getUser();
    int i = 0;
    log("getImage === ${i++}");

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gallery')
        .where('type', isEqualTo: 'image')
        .snapshots();
  }
}

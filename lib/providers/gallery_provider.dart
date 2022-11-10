import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:utara_drive/helper/helper.dart';

class GalleryProvider with ChangeNotifier {
  List galleryList = [];

  List imageList = [];

  bool isLoading = false;

  User user = Helper().getUser();

  Future initData() async {
    await getGallery();
    await getImage();
  }

  Future getGallery() async {
    isLoading = true;
    notifyListeners();

    List tmpGallery = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gallery')
        .orderBy('created_at', descending: true)
        // .where('type', isEqualTo: 'image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        tmpGallery.add(doc);
      }
      galleryList = tmpGallery;
      isLoading = false;

      log('Gallery List === ${galleryList.length}');
      notifyListeners();
    });
  }

  Future getImage() async {
    isLoading = true;
    notifyListeners();

    List tmpGallery = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gallery')
        .orderBy('created_at', descending: true)
        .where('type', isEqualTo: 'image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        tmpGallery.add(doc);
      }
      imageList = tmpGallery;
      isLoading = false;

      log('Image List === ${imageList.length}');
      notifyListeners();
    });
  }

  Future getVideo() async {}

  Future getAlbum() async {}

  // Stream getImage() {
  //   User user = Helper().getUser();
  //   int i = 0;
  //   log("getImage === ${i++}");

  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('gallery')
  //       .where('type', isEqualTo: 'image')
  //       .snapshots();
  // }

}

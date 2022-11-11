import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class GalleryProvider with ChangeNotifier {
  late User user = FirebaseAuth.instance.currentUser as User;
  List galleryList = [];

  List imageList = [];

  bool isLoading = false;

  initData() {
    getGallery();
    getImage();
  }

  Future getGallery() async {
    log('UID NIH === ${user.uid}');
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
    }).onError(
      (error, stackTrace) {
        log('Failed to get gallery: $error');
      },
    );
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
    }).onError(
      (error, stackTrace) {
        log('Failed to get image: $error');
      },
    );
  }

  Future getVideo() async {}


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

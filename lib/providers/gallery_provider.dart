import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:utara_drive/helper/helper.dart';

class GalleryProvider with ChangeNotifier {
  List galleryist = [];

  bool isLoading = false;

  // getGallery() async {
  //   User user = Helper().getUser();
  //   List docList = [];

  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('gallery')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       docList.add(doc.data());
  //     }

  //     galleryist = docList;
  //     log('querySnapshot === $galleryist');
  //     notifyListeners();
  //   }).catchError((onError) {
  //     log('onError === $onError');
  //   });

  //   return docList;
  // }

  Stream getGallery() {
    User user = Helper().getUser();
    int i = 0;
    log("${i++}");

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gallery')
        .snapshots();
  }
}

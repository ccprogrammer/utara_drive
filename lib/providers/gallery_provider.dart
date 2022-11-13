import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class GalleryProvider with ChangeNotifier {
  late User user = FirebaseAuth.instance.currentUser as User;

  final searchC = TextEditingController();

  List galleryList = [];
  List imageList = [];
  List videoList = [];
  List searchList = [];

  bool isLoading = false;
  bool isSearchLoading = false;

  initData() {
    getGallery();
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

      imageList =
          tmpGallery.where((element) => element['type'] == 'image').toList();
      videoList =
          tmpGallery.where((element) => element['type'] == 'video').toList();

      isLoading = false;
      notifyListeners();
    }).catchError(
      (error) {
        log('Failed to get gallery: $error');
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future searchGallery() async {
    isSearchLoading = true;
    notifyListeners();

    searchList = searchC.text != ''
        ? galleryList
            .where(
              (element) =>
                  element['label'].toLowerCase().contains(
                        searchC.text.toLowerCase().trim(),
                      ) ||
                  element['description'].toLowerCase().contains(
                        searchC.text.toLowerCase().trim(),
                      ),
            )
            .toList()
        : [];

    for (var item in searchList) {
      log('SEARCH RESULT: ${item['label']} === ${item.data()}');
    }

    isSearchLoading = false;
    notifyListeners();
  }

  clearSearch() {
    searchC.clear();
    searchList.clear();
  }
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

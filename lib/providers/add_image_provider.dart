import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utara_drive/helper/remove_string.dart';

class AddImageProvider with ChangeNotifier {
  bool isLoading = false;
  List tagList = [];

  var descriptionC = TextEditingController();
  var locationC = TextEditingController();
  var tagC = TextEditingController();

  // upload image to firebase
  addImage(context, XFile xImage) async {
    isLoading = true;
    notifyListeners();

    // get user uid
    User user = FirebaseAuth.instance.currentUser as User;

    // get image file and name
    File image = File(xImage.path);
    String imageName = removeString(xImage.name);

    // upload image to cloud storage
    var ref = FirebaseStorage.instance
        .ref()
        .child('${user.displayName!}_${user.uid}')
        .child('images')
        .child(imageName);

    try {
      await ref.putFile(image);
    } on FirebaseException catch (e) {
      log('FirebaseException storage === $e');
    }

    // upload to cloud firestore
    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('images')
        .doc()
        .set({
          'username': user.displayName,
          'uid': user.uid,
          'image_name': imageName,
          'description': descriptionC.text,
          'location': locationC.text,
          'tag': tagList,
          'type': 'image',
          'date': DateTime.now(),
          'image_url': url,
        })
        .then((value) => log("Image Added"))
        .catchError((error) => log("Failed to add image: $error"));

    // month/day/year time
    // DateFormat.yMd().add_jm().format(DateTime.now())

    isLoading = false;
    notifyListeners();

    clearData();
    Navigator.pop(context);
  }

  // handle tag
  addTag() {
    if (tagC.text.isNotEmpty) {
      tagList.add(tagC.text.trim());
      tagC.clear();
      log('tagList === $tagList');
      notifyListeners();
    }
  }

  deleteTag(tag) {
    tagList.removeWhere((element) {
      return element == tag;
    });

    notifyListeners();
  }

  // clear data
  clearData() {
    descriptionC.clear();
    locationC.clear();
    tagC.clear();
    tagList.clear();
  }
}

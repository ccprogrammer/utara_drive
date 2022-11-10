import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/helper/remove_string.dart';
import 'package:utara_drive/themes/my_themes.dart';

class AddGalleryProvider with ChangeNotifier {
  bool isLoading = false;
  List tagList = [];

  var labelC = TextEditingController();
  var descriptionC = TextEditingController();
  var locationC = TextEditingController();
  var tagC = TextEditingController();

  // upload gallery to firebase
  Future addGallery(context, XFile xImage) async {
    isLoading = true;
    notifyListeners();

    // get user uid
    User? user = FirebaseAuth.instance.currentUser;

    // get image file and name
    File image = File(xImage.path);
    String imageName = removeString(xImage.name);

    // upload image to cloud storage
    var ref = FirebaseStorage.instance
        .ref()
        .child('${user!.displayName}_${user.uid}')
        .child('images')
        .child(imageName);

    try {
      await ref.putFile(image);

      // get image download url
      final url = await ref.getDownloadURL();

      // upload to cloud firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('gallery')
          .doc()
          .set({
        'username': user.displayName,
        'uid': user.uid,
        'label': labelC.text,
        'image_name': imageName,
        'description': descriptionC.text,
        'location': locationC.text,
        'tag': tagList,
        'type': 'image',
        'created_at': Timestamp.now(),
        'date': DateTime.now(),
        'image_url': url,
      });

      isLoading = false;
      clearData();
      notifyListeners();
      Navigator.pop(context);

      Helper(context: context).showNotif(
        title: 'Success',
        message: 'Image has been uploaded',
        color: MyTheme.colorCyan,
      );
    } on FirebaseException catch (e) {
      log('FirebaseException  === $e');
      Helper(context: context).showNotif(
        title: 'Failed',
        message: 'An error occurred, $e',
      );
    }

    // month/day/year time
    // DateFormat.yMd().add_jm().format(DateTime.now())
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
    labelC.clear();
    descriptionC.clear();
    locationC.clear();
    tagC.clear();
    tagList.clear();
  }
}

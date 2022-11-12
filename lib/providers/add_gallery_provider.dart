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
  // COBA CARI CARA UNTUK MEMASUKAN ID KEDALAM OBJECT GALLERY SAAT UPLOAD

  late User user = FirebaseAuth.instance.currentUser as User;

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

    // get image file and name
    File image = File(xImage.path);
    String imageName = removeString(xImage.name);

    // upload image to cloud storage
    var ref = FirebaseStorage.instance
        .ref()
        .child('${user.displayName}_${user.uid}')
        .child('images')
        .child(imageName);

    await ref
        .putFile(image)
        .then((value) => log("gallery uploaded to cloud storage"))
        .catchError((error) =>
            log("Failed to uploaded gallery to cloud storage: $error"));

    // get image download url
    final url = await ref.getDownloadURL();

    // upload to cloud firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gallery')
        .doc()
        .set({
      'id': null,
      'username': user.displayName,
      'label': labelC.text,
      'image_name': imageName,
      'description': descriptionC.text,
      'location': locationC.text,
      'tag': tagList,
      'type': 'image',
      'created_at': Timestamp.now(),
      'image_url': url,
    }).then((value) {
      Navigator.pop(context);
      Helper(ctx: context).showNotif(
        title: 'Success',
        message: 'Image has been uploaded',
        color: MyTheme.colorCyan,
      );
      log("gallery added");
    }).catchError((error) {
      Helper(ctx: context).showNotif(
        title: 'Failed',
        message: 'Image failed to upload',
      );
      log("Failed to add gallery: $error");
    });

    isLoading = false;
    clearData();
    notifyListeners();
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

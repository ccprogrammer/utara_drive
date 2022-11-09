import 'dart:developer';
import 'dart:io';

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

    User user = FirebaseAuth.instance.currentUser as User;
    File image = File(xImage.path);
    String imageName = removeString(xImage.name);

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

    final url = await ref.getDownloadURL();

    log('ref.getDownloadURL() === $url');

    isLoading = false;
    notifyListeners();
  }

  // handle tag
  addTag() {
    if (tagC.text.isNotEmpty) {
      tagList.add(tagC.text);
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

  //...
}

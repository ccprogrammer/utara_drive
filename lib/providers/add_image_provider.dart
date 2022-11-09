import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';

class AddImageProvider with ChangeNotifier {
  File? image;
  List tagList = [];

  var descriptionC = TextEditingController();
  var locationC = TextEditingController();
  var tagC = TextEditingController();

  // upload image to firebase
  addImage() {
    log('description === ${descriptionC.text}');
    log('location === ${locationC.text}');
    log('tag === ${tagC.text}');
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

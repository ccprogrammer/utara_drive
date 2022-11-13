import 'package:flutter/widgets.dart';

class EditGalleryProvider with ChangeNotifier {
  var labelC = TextEditingController();
  var descriptionC = TextEditingController();
  var locationC = TextEditingController();
  var tagC = TextEditingController();

  initTextController({label, description, location}) {
    labelC.text = label;
    descriptionC.text = description;
    locationC.text = location;
    notifyListeners();
  }

  Future editGallery(docId) async {}
}

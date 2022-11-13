import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';

class EditGalleryProvider with ChangeNotifier {
  late User user = FirebaseAuth.instance.currentUser as User;

  bool isLoading = false;

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

  Future editGallery(context, gallery) async {
    isLoading = true;
    notifyListeners();

    String docId =
        gallery is QueryDocumentSnapshot ? gallery.id : gallery['id'];

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('gallery')
          .doc(docId)
          .update(
        {
          'id': docId,
          'label': labelC.text,
          'description': descriptionC.text,
          'location': locationC.text,
        },
      ).then((value) {
        Navigator.pop(context);
        Helper(ctx: context).showNotif(
          title: 'Success',
          message: 'Gallery edited',
          color: MyTheme.colorCyan,
        );

        Provider.of<GalleryProvider>(context, listen: false).getGallery();
      }).catchError((onError) {
        Helper(ctx: context).showNotif(
          title: 'Failed',
          message: 'Failed to edit gallery',
        );
      });
    } on FirebaseException catch (e) {
      Helper(ctx: context).showNotif(
        title: 'Failed',
        message: 'Failed to edit gallery: $e',
      );
    }

    isLoading = false;
    notifyListeners();
  }
}

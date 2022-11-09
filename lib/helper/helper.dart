
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/screen/add_screen/add_screen.dart';

class Helper {
  Helper({this.context});
  BuildContext? context;

  // show alert notification/flushbar
  showNotif({required String title, required String message}) {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: MyTheme.colorRed,
    ).show(context!);
  }

  // show alert dialog
  Future showAlertDialog({
    required BuildContext context,
    text = 'dialog label',
    icon = Icons.warning,
    String titleLeft = 'No',
    String titleRight = 'Yes',
    Function? onClose,
    Function? onYes,
    Function? onNo,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: MyTheme.colorRed,
                ),
                const SizedBox(height: 24),
                Text(
                  text,
                  style: const TextStyle(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onNo != null ? onNo() : null;
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.colorCyan,
                        ),
                        child: Text(titleLeft),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onYes != null ? onYes() : null;
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.colorRed,
                        ),
                        child: Text(titleRight),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).then((value) => onClose != null ? onClose() : null);
  }

  //  handle camera/gallery
  Future openGalleryPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    return pickedImage;
  }

  Future openGalleryVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickVideo(source: ImageSource.gallery);

    return pickedImage;
  }

  Future openCameraPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);

    return pickedImage;
  }

  Future openCameraVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickVideo(source: ImageSource.camera);

    return pickedImage;
  }

  Future showImageDialog({
    required BuildContext context,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      openGalleryPhoto().then(
                        (image) {
                          if (image != null) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    AddScreen(image: image, imageType: 'image'),
                              ),
                            );
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.colorCyan,
                    ),
                    child: const Text('Gallery Image'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      openGalleryVideo().then(
                        (image) {
                          if (image != null) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    AddScreen(image: image, imageType: 'video'),
                              ),
                            );
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.colorCyan,
                    ),
                    child: const Text('Gallery Video'),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

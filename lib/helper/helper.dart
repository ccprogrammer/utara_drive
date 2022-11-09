import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utara_drive/themes/my_themes.dart';

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
    File image = File(pickedImage!.path);

    log('XFILE Image === $pickedImage');
    log('FILE Image === $image');

    return image;
  }

  Future openGalleryVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickVideo(source: ImageSource.gallery);
    File image = File(pickedImage!.path);

    log('XFILE Image === $pickedImage');
    log('FILE Image === $image');

    return image;
  }

  Future openCameraPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);
    File image = File(pickedImage!.path);

    log('XFILE Image === $pickedImage');
    log('FILE Image === $image');

    return image;
  }

  Future openCameraVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickVideo(source: ImageSource.camera);
    File image = File(pickedImage!.path);

    log('XFILE Image === $pickedImage');
    log('FILE Image === $image');

    return image;
  }
  // ...
}

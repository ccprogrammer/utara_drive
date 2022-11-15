import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:utara_drive/providers/add_album_provider.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/custom_text_field2.dart';
import 'package:utara_drive/ui/screen/add_screen/add_screen.dart';
import 'package:http/http.dart' as http;

class Helper {
  Helper({this.ctx});
  BuildContext? ctx;

  // convert timestamp
  convertTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    final date = DateFormat.yMd().add_jm().format(dateTime);

    return date;
  }

  // show alert notification/flushbar
  showNotif(
      {required String title,
      required String message,
      Color color = MyTheme.colorRed}) {
    return Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color,
    ).show(ctx!);
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
    bool oneButton = false,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: MyTheme.colorBlueGrey,
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
                  style: const TextStyle(color: MyTheme.colorGrey),
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
                          backgroundColor: MyTheme.colorDarkGrey,
                        ),
                        child: Text(titleLeft),
                      ),
                    ),
                    if (!oneButton) const SizedBox(width: 24),
                    if (!oneButton)
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

  // share image
  shareContent({image}) async {
    final imageUrl = Uri.parse(image['image_url']);

    final response = await http.get(imageUrl);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/${image['image_name']}';

    File(path).writeAsBytes(bytes);
    // ignore: deprecated_member_use
    await Share.shareFiles([path], subject: 'Image', text: '');
  }

  downloadFileFromUrl({url}) async {
    await Permission.storage.request();
    final Directory directory = await getApplicationDocumentsDirectory();

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir:
          Platform.isAndroid ? '/storage/emulated/0/Download/' : directory.path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    log('taskId $taskId');
  }

  //  handle camera/gallery
  Future openGalleryPhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              AddScreen(image: pickedImage, imageType: 'image'),
        ),
      ).then(
        (value) =>
            Provider.of<GalleryProvider>(context, listen: false).getGallery(),
      );
    }
  }

  Future openGalleryVideo(context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickVideo(source: ImageSource.gallery);

    if (pickedImage != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              AddScreen(image: pickedImage, imageType: 'video'),
        ),
      ).then(
        (value) =>
            Provider.of<GalleryProvider>(context, listen: false).getGallery(),
      );
    }
  }

  Future openCameraPhoto(context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              AddScreen(image: pickedImage, imageType: 'image'),
        ),
      ).then(
        (value) =>
            Provider.of<GalleryProvider>(context, listen: false).getGallery(),
      );
    }
  }

  Future openCameraVideo(context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickVideo(source: ImageSource.camera);

    if (pickedImage != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              AddScreen(image: pickedImage, imageType: 'video'),
        ),
      ).then(
        (value) =>
            Provider.of<GalleryProvider>(context, listen: false).getGallery(),
      );
    }
  }

  // handle album
  Future showAlbumDialog({
    required BuildContext context,
  }) {
    var labelC = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: MyTheme.colorBlueGrey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content:
                Consumer<AddAlbumProvider>(builder: (context, provider, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create an album',
                    style: TextStyle(
                      color: MyTheme.colorGrey,
                      fontSize: 16,
                    ),
                  ),
                  CustomTextField2(
                    hint: 'Enter label',
                    controller: labelC,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.createAlbum(context, labelC.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyTheme.colorCyan,
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  // show gallery detail modal
  void showCustomModal({
    double elevation = 1,
    required BuildContext context,
    required Widget child,
  }) {
    showModalBottomSheet(
      elevation: elevation,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => child,
    );
  }
}

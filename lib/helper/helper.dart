import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/add_album_provider.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/custom_text_field2.dart';
import 'package:utara_drive/ui/screen/add_screen/add_screen.dart';

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
                          backgroundColor: MyTheme.colorDarkGrey,
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
    bool isCamera = false,
  }) {
    getGallery(image, String type) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => AddScreen(image: image, imageType: type),
        ),
      ).then(
        (value) =>
            Provider.of<GalleryProvider>(context, listen: false).getGallery(),
      );
    }

    return showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.8),
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      isCamera
                          ? openCameraPhoto().then(
                              (image) {
                                Navigator.pop(context);
                                if (image != null) {
                                  getGallery(image, 'image');
                                }
                              },
                            )
                          : openGalleryPhoto().then(
                              (image) {
                                Navigator.pop(context);
                                if (image != null) {
                                  getGallery(image, 'image');
                                }
                              },
                            );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.colorCyan,
                    ),
                    child: Text(isCamera ? 'Photo' : 'Image'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      isCamera
                          ? openCameraVideo().then(
                              (image) {
                                Navigator.pop(context);
                                if (image != null) {
                                  getGallery(image, 'video');
                                }
                              },
                            )
                          : openGalleryVideo().then(
                              (image) {
                                Navigator.pop(context);
                                if (image != null) {
                                  getGallery(image, 'video');
                                }
                              },
                            );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.colorCyan,
                    ),
                    child: const Text('Video'),
                  ),
                ),
              ],
            ),
          );
        });
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
                      color: MyTheme.colorBlack,
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
                                  color: MyTheme.colorWhite,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Text('Create'),
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

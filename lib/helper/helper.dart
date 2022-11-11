
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
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCamera ? 'Take from camera' : 'Take from gallery',
                  style: const TextStyle(
                    color: MyTheme.colorBlack,
                    fontSize: 16,
                  ),
                ),
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
    bool isCamera = false,
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
                        provider.createAlbum(labelC.text).then((value) {
                          Navigator.pop(context);
                          Helper(ctx: context).showNotif(
                              title: 'Success',
                              message: 'New album added',
                              color: MyTheme.colorCyan);
                        });
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
  }) {
    showModalBottomSheet(
      elevation: elevation,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Line
          Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            width: 28,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Sheet Title
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: const Text(
                'Choose Language / Pilih Bahasa',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          // Sheet Subtitle
          Container(
            margin: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: const Text(
              'Which language do you prefer? / Bahasa mana yang Anda sukai?',
              style: TextStyle(
                fontSize: 13,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          // Sheet Button 1
          Container(
            margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0),
              child: const Text(
                'Lanjutkan menggunakan bahasa Indonesia',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),

          // Sheet Button 2
          Container(
            margin: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0),
              child: const Text(
                'Continue in English',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

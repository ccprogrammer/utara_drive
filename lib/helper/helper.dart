import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';

class Helper {
  Helper({this.context});
  BuildContext? context;

  // show alert notification
  showNotif({required String title, required String message}) {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: MyTheme.colorRed,
    ).show(context!);
  }

  Future showAlertDialog({
    required BuildContext context,
    text = 'dialog label',
    icon = Icons.warning,
    Function? onClose,
    Function? onYes,
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
                Container(
                  child: Text(
                    text,
                    style: const TextStyle(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.colorCyan,
                        ),
                        child: const Text('Close'),
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
                        child: const Text('Log Out'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).then((value) => onClose != null ? onClose() : null);
  }
}

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';

class helper {
  helper({this.context});
  BuildContext? context;

  showNotif({required String title, required String message}) {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: MyTheme.colorRed,
    ).show(context!);
  }
}

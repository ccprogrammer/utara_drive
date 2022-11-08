import 'dart:developer';

import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool isLogin = true;

  var emailC = TextEditingController();
  var usernameC = TextEditingController();
  var passwordC = TextEditingController();

  switchLogin() {
    isLogin = !isLogin;
    notifyListeners();
  }

  logIn() {
    log('emailC === ${emailC.text}');
    log('passwordC === ${passwordC.text}');
  }

  signUp() {
    log('emailC === ${emailC.text}');
    log('usernameC === ${usernameC.text}');
    log('passwordC === ${passwordC.text}');
  }
}

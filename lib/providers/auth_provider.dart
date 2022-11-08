import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  dynamic credential;

  bool isLogin = true;

  var emailC = TextEditingController();
  var usernameC = TextEditingController();
  var passwordC = TextEditingController();

  switchLogin() {
    isLogin = !isLogin;
    notifyListeners();
  }

  logIn() {
    if (!validateAuth()) return;
    log('emailC === ${emailC.text}');
    log('passwordC === ${passwordC.text}');
  }

  signUp() async {
    if (!validateAuth()) return;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailC.text,
        password: passwordC.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }

    // log('emailC === ${emailC.text}');
    // log('usernameC === ${usernameC.text}');
    // log('passwordC === ${passwordC.text}');
  }

  bool validateAuth() {
    bool isValid = true;
    String message = '';
    if (!emailC.text.contains('@')) {
      message = 'Please enter the correct email';
      isValid = false;
    } else if (!isLogin && usernameC.text.length < 6) {
      message = 'Username minimum must be 8';
      isValid = false;
    } else if (passwordC.text.length < 8) {
      message = 'Password minimum must be 8';
      isValid = false;
    }

    log('final message === $message');

    return isValid;
  }
}

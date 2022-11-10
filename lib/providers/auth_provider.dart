import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';

class AuthProvider with ChangeNotifier {
  late UserCredential credential;

  bool isLogin = true;
  bool isLoading = false;

  var emailC = TextEditingController();
  var usernameC = TextEditingController();
  var passwordC = TextEditingController();

  // switch log in to sign up
  switchLogin() {
    isLogin = !isLogin;
    notifyListeners();
  }

  // log in function
  logIn(context) async {
    if (!validateAuth(context)) return;

    isLoading = true;
    notifyListeners();

    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailC.text,
        password: passwordC.text,
      );

      Helper(context: context).showNotif(
        title: 'Success',
        message: 'Log in successfully, ',
        color: MyTheme.colorCyan,
      );

      log('log in succeed === $credential');
    } on FirebaseAuthException catch (e) {
      String title = 'Failed';
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
        log('Wrong password provided for that user.');
      }

      Helper(context: context).showNotif(
        title: title,
        message: message,
        color: MyTheme.colorRed,
      );
    } catch (e) {
      log(e.toString());
      Helper(context: context).showNotif(
        title: 'Failed',
        message: e.toString(),
        color: MyTheme.colorRed,
      );
    }

    isLoading = false;
    notifyListeners();
  }

  // sign up function
  signUp(context) async {
    if (!validateAuth(context)) return;
    isLoading = true;
    notifyListeners();

    try {
      // registering new account
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailC.text.toLowerCase(),
        password: passwordC.text.toLowerCase(),
      );
      await credential.user?.updateDisplayName(usernameC.text);

      // add user info to cloud firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid)
          .set({
            'email': emailC.text.toLowerCase(),
            'username': usernameC.text.toLowerCase(),
          })
          .then((value) => log("User Added"))
          .catchError((error) => log("Failed to add user: $error"));

      Helper(context: context).showNotif(
        title: 'Success',
        message: 'Sign Up successfully, ',
        color: MyTheme.colorCyan,
      );
      log('sign up succeed === $credential');
    } on FirebaseAuthException catch (e) {
      String title = 'Failed';
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
        log('The account already exists for that email.');
      }

      Helper(context: context).showNotif(
        title: title,
        message: message,
        color: MyTheme.colorRed,
      );
    } catch (e) {
      log(e.toString());
      Helper(context: context).showNotif(
        title: 'Failed',
        message: e.toString(),
        color: MyTheme.colorRed,
      );
    }

    isLoading = false;
    notifyListeners();
  }

  // sign out function
  signOut(context) {
    Helper().showAlertDialog(
      context: context,
      text: 'Are you sure want to log out?',
      onYes: () async => await FirebaseAuth.instance.signOut(),
    );
  }

  // check auth state
  authState(context) async {
    return FirebaseAuth.instance.authStateChanges().listen((User? user) {
      log('authStateChanges === $user');
      if (user == null) {
        Navigator.pushNamed(context, AppRoute.auth);
        log('User is currently signed out!');
      } else {
        Navigator.pushNamed(context, AppRoute.mainScreen);
        log('User is signed in!');
      }
    });
  }

  // text field validation
  bool validateAuth(context) {
    bool isValid = true;
    String message = '';
    if (!emailC.text.contains('@')) {
      message = 'Please enter a valid email address.';
      isValid = false;
    } else if (!isLogin && usernameC.text.length < 6) {
      message = 'Please enter at least 6 characters';
      isValid = false;
    } else if (passwordC.text.length < 8) {
      message = 'Password must be at least 8 characters long.';
      isValid = false;
    }

    if (!isValid) {
      Helper(context: context).showNotif(title: 'Alert', message: message);
    }

    log(message.toString());
    return isValid;
  }
}

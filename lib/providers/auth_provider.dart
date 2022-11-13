import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
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
    isLoading = true;
    notifyListeners();

    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailC.text,
        password: passwordC.text,
      );

      Helper(ctx: context).showNotif(
        title: 'Success',
        message: 'Log in successfully, ',
        color: MyTheme.colorCyan,
      );

      clearTextField();
      log('log in succeed === $credential');
    } on FirebaseAuthException catch (e) {
      Helper(ctx: context).showNotif(
        title: 'Failed',
        message: e.message.toString(),
      );
    } catch (e) {
      log(e.toString());
      Helper(ctx: context).showNotif(
        title: 'Error',
        message: 'An error occurred, please try again',
      );
    }

    isLoading = false;
    notifyListeners();
  }

  // sign up function
  signUp(context) async {
    isLoading = true;
    notifyListeners();

    try {
      // registering new account
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailC.text.toLowerCase(),
        password: passwordC.text.toLowerCase(),
      );
      await credential.user?.updateDisplayName(usernameC.text);

      Provider.of<GalleryProvider>(context, listen: false);

      // add user info to cloud firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid)
          .set({
        'id': credential.user?.uid,
        'email': emailC.text.toLowerCase(),
        'username': usernameC.text.toLowerCase(),
      }).then((value) {
        Helper(ctx: context).showNotif(
          title: 'Success',
          message: 'Sign Up successfully, ',
          color: MyTheme.colorCyan,
        );
        log('sign up success === $credential');
      });

      clearTextField();
    } on FirebaseAuthException catch (e) {
      Helper(ctx: context).showNotif(
        title: 'Failed',
        message: e.message.toString(),
      );
      log('sign up failed === $e');
    } catch (e) {
      log(e.toString());
      Helper(ctx: context).showNotif(
        title: 'Error',
        message: 'An error occurred, please try again',
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
      icon: Icons.logout,
      onYes: () async => await FirebaseAuth.instance.signOut(),
    );
  }

  clearTextField() {
    emailC.clear();
    usernameC.clear();
    passwordC.clear();
  }
}

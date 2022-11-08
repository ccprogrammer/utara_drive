import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/routes/routes.dart';

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

      log('log in succeed === $credential');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
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

      // Navigator.pushNamed(context, AppRoute.home);
      log('sign up succeed === $credential');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
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
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
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

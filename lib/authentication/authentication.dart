import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/authScreen.dart';
import 'package:todo/authentication/googleSignIn.dart';
import 'package:todo/models/addImageUrl.dart';

import '../screens/todoPage.dart';

Future<void> signInUsingEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      print('Routing to todo with signIn');
      ;
      log('uid : ${auth.currentUser!.uid}');
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => TodoPage()));
      clearAuthController();
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      const snackBar = SnackBar(
        content: Text('Invalid User'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      const snackBar = SnackBar(
        content: Text('Incorrect Password'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

Future<dynamic> signUp(String email, String password, String cPassword,
    String username, String url, BuildContext context) async {
  if (password == cPassword) {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      log('$userCredential');
      await addImageUrl(url);
      await userCredential.user!.updateDisplayName(username);
      await userCredential.user!.updatePhotoURL(url);
      print('update display name and image');
      print('Signed Up >>> Routing to todo with signUp ---');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthScreen()));
    } on FirebaseAuthException catch (e) {
      print('signUp error : $e');
    }
  } else {
    const snackBar = SnackBar(content: Text('Password should be same'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/authentication/googleSignIn.dart';

class CategoryService {
  FirebaseFirestore? _instance;

  List<CatData> _catData = [];

  List<CatData> getCatData() {
    return _catData;
  }

  Future<void> getCatDataCollectionFromFirebase() async {
    _instance = FirebaseFirestore.instance;

    CollectionReference catData = _instance!.collection('tasks');

    DocumentSnapshot snapshot = await catData
        .doc(auth.currentUser!.uid)
        .collection('barData')
        .doc('catData')
        .get();

    var data = snapshot.data() as Map;

    var _categoryData = data['catData'] as List<dynamic>;

    _categoryData.forEach((e) {
      // covert into appropriate model ok

      //
      _catData.add(e);
      //
      print(e);
    });
  }
}

class CatData {
  final val;

  CatData(this.val);
}

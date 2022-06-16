import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/authentication/googleSignIn.dart';

addImageUrl(String url) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(auth.currentUser!.uid)
      .collection('profileUrl')
      .add({
    'profileUrl': url,
  });
}

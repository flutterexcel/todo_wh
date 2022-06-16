import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/todoPage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> signIn(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    UserCredential result = await auth.signInWithCredential(authCredential);
    User? user = result.user;
    if (result != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TodoPage(),
          ));
    }
  }
}

signOut() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await auth.signOut();
  await googleSignIn.signOut();
}

showProfile(BuildContext context) {
  // log('photo URL >> ${auth.currentUser?.photoURL}');
  if (auth.currentUser?.photoURL != null) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ClipOval(
        child: Material(
          child: Image.network(
            "${auth.currentUser?.photoURL}",
            fit: BoxFit.fill,
            height: 50,
            width: 50,
          ),
        ),
      ),
    );
  } else {
    return Icon(Icons.account_circle, size: 50);
  }
}

showUserName(BuildContext context) {
  // log('show username >> ${auth.currentUser?.displayName}');
  final User? user = auth.currentUser;
  if (auth.currentUser != null) {
    return Text(
      '${user?.displayName}',
      style: TextStyle(fontSize: 22, color: Color.fromARGB(255, 73, 17, 10)),
    );
    print('${user?.displayName}');
  } else {
    return Text(
      'user_name',
    );
  }
}

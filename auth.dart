import 'package:event_booking_app/pages/bottomnav.dart';
import 'package:event_booking_app/services/database.dart';
import 'package:event_booking_app/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;
    await SharedpreferenceHelper().saveUserEmail(userDetails!.email!);
    await SharedpreferenceHelper().saveUserName(userDetails.displayName!);
    await SharedpreferenceHelper().saveUserImage(userDetails.photoURL!);
    await SharedpreferenceHelper().saveUserId(userDetails.uid);

    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        'Name': userDetails!.displayName,
        'Image': userDetails!.photoURL,
        'Email': userDetails!.email,
        'Id': userDetails!.uid,
      };
      await DatabaseMethods().addUserDetail(userInfoMap, userDetails.uid);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Registered successfully!!!',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    }
  }

  Future SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteuser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}

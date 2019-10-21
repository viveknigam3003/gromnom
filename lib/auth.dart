import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password);
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<FirebaseUser> signInWithGoogle();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      print("signed in " + user.displayName);
      return user;
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return user;
    } catch (PlatformException) {
      print("Wrong Email Format");
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    try {
      return user.uid;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map> login({
    @required String email,
    @required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("Succesfully Login");
      return {'status': true, 'data': 'Succesfully Login'};
    } on FirebaseAuthException catch (e) {
      return {'status': false, 'data': e.message};
    } catch (e) {
      print(e.message);
      return {'status': false, 'data': e.message};
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Use the `credential` to sign in to your Firebase project if you are using Firebase.
      // For other authentication mechanisms, refer to the relevant documentation.

      // Example of using Firebase Auth:
      // final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      // final User? user = userCredential.user;

      // Perform further actions after successful sign-in

    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<Map> signUp({
    @required String email,
    @required String password,
    @required String name,
  }) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = uc.user;
      await user.updateProfile(displayName: name);
      return {'status': true, 'data': registerDoneDescription};
    } on FirebaseAuthException catch (e) {
      return {'status': false, 'data': e.message};
    } catch (e) {
      print(e.message);
      return {'status': false, 'data': e.message};
    }
  }

  Future<Map> updateEmail({@required String newEmail}) async {
    try {
      User currentUser = getCurrentUser();
      if (currentUser.email == newEmail) {
        return {'status': false, 'data': emailUpdateSameEmail};
      }
      await currentUser.updateEmail(newEmail);
      print('Email Updated!');
      return {'status': true, 'data': emailUpdateDescription};
    } on FirebaseAuthException catch (e) {
      return {'status': false, 'data': e.message};
    } catch (e) {
      print(e.message);
      return {'status': false, 'data': e.message};
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User getCurrentUser() {
    final User user = _auth.currentUser;
    return user;
  }
}

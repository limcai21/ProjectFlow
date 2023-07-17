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

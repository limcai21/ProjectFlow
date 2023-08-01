import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ProjectFlow/pages/global/constants.dart';

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

  Future<Map<dynamic, dynamic>> updatePassword({
    @required String currentPassword,
    @required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final cred = EmailAuthProvider.credential(
      email: user.email,
      password: currentPassword,
    );

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      print("Password updated");
      return {'status': true, 'message': 'Password Updated'};
    } catch (error) {
      print("Failed to update password: ${error.message}");
      return {'status': false, 'message': error.message.toString()};
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Map<dynamic, dynamic>> deleteAccount() async {
    try {
      User user = this.getCurrentUser();
      await user.delete();
      print("User account deleted successfully!");
      return {"status": true, "data": "User account deleted successfully!"};
    } catch (e) {
      print("Error deleting user account: $e");
      return {'status': false, 'data': "Error deleting user account: $e"};
    }
  }

  User getCurrentUser() {
    final User user = _auth.currentUser;
    return user;
  }
}

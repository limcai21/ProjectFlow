import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> login({String email, String password}) async {
    try {
      UserCredential uc = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = uc.user;
      print("Succesfully Login");
      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      print(e.message);
      return null;
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

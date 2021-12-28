import 'package:firebase_auth/firebase_auth.dart';

import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/core/services/user_service.dart';

class AuthenticateService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserService _userService = new UserService();
  String _uId;

  Future<FirebaseUser> getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    // if (user != null) {
      return user;
    // }
    //  else {
    //   return null;
    // }
  }

  Future<String> getCurrentUserId() async {
    final FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      _uId = user.uid;
      print('uId from auth >>>>>>>>>>>>>>  ' + _uId);
    }
    return _uId;
  }

  User userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User() : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(userFromFirebaseUser);
  }

  // sign in anonymous
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      return userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    var role,
  ) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;

      print('roleObject from auth 1 >>>>>>>>>>>>>>  ' + role.toString());

      // create a new document for the user with the uId
      User userModel = new User.fromUser(
        uId: user.uid,
        email: user.email.toLowerCase().trim(),
        password: password.trim(),
        name: name.trim(),
        photo: 'no-photo',
        role: role,
        target: 'no-target',
        gender: 'no-gender',
        calculation: 'no-calculation',
        age: 0,
        weight: 0,
        height: 0,
        activity: 'no-activity',
      );
      print('role from userModel >>>>>>>>>>>>>>  ' +
          userModel.getRole.toString());

      await _userService.updateUser(userModel, user.uid);

      print('roleObject from auth 2 >>>>>>>>>>>>>>  ' + role.toString());

      return userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // send reset password email
  Future<void> resetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

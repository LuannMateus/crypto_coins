import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthException implements Exception {
  String message;

  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  void _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      user = (user == null) ? null : user;

      isLoading = false;

      notifyListeners();
    });
  }

  void _getUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        throw AuthException('The password is to week!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('The email is already used!');
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw AuthException('Email/Password is wrong! Try again.');
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _getUser();
  }
}

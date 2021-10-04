import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Auth() {
    final User? _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _user = _currentUser;
      notifyListeners();
    }
  }

  User? get user => _user;
  bool get loggedIn => _user != null;

  Future<bool> login(String email, String password) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );
      _user = _userCredential.user;
      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential _userCredential = await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
      _user = _userCredential.user;
      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    await _auth.signOut();
    notifyListeners();
  }
}
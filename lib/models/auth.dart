import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool get confirmed => _user != null && _user!.emailVerified;

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
      final params = {'email': email, 'uid': _user!.uid};
      String url = 'http://127.0.0.1:3000/api/users';
      final response = await http.post(Uri.parse(url),
        body: json.encode(params),
        headers: {"Content-Type": "application/json"}
      );
      if (response.statusCode == 200) {
        _user!.sendEmailVerification(); // 認証メールを送信
        notifyListeners();
      }
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
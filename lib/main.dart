import 'package:flutter/material.dart';
import './service/auth_service.dart';
import './ui/pages/login_page.dart';
import './ui/pages/main_page.dart';
import './ui/pages/verification_page.dart';
import './ui/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthCredential? _credential;

  // Firebase 認証
  final auth = FirebaseAuth.instance;
  AuthResult? _result;
  FirebaseUser? _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage()
    );
  }
}
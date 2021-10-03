import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/ui/pages/main_page.dart';
import './ui/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _LoginCheck()
    );
  }
}

// 新たに追加
class _LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Firebase 認証
    final auth = FirebaseAuth.instance;
    // ログイン状態に応じて、画面を切り替える
    final User? _currentUser = auth.currentUser;
    return _currentUser != null ? MainPage(userId: _currentUser.uid) : LoginPage();
  }
}
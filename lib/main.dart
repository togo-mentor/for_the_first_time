import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:for_the_first_time/ui/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

import './ui/pages/main_page.dart';

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
  // Google 認証
  final _google_signin  = GoogleSignIn(scopes: [
     'email',
     'https://www.googleapis.com/auth/contacts.readonly',
    ]);
  late GoogleSignInAccount googleUser;
  late GoogleSignInAuthentication googleAuth;
  late AuthCredential credential;

  // Firebase 認証
  final _auth = FirebaseAuth.instance;
  UserCredential? result;
  User? user;
  bool inSignedIn = false;

  @override

  void initState() {
    super.initState();
  }

  void shouldLogOut() async {
    await _auth.signOut();
    await _google_signin.signOut();
    print('サインアウトしました。');
  }

  void shouldLogin() async {
    result = await _auth.signInWithCredential(credential);
    user = result!.user;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(shouldLogOut: shouldLogOut, userId: user!.uid),
      )
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: user == null ? LoginPage(shouldLogin: shouldLogin) : MainPage(shouldLogOut: shouldLogOut, userId: user!.uid)
    );
  }
}
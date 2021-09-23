import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:for_the_first_time/ui/pages/create_memo_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import './ui/pages/login_page.dart';
import './ui/pages/main_page.dart';
import './ui/pages/verification_page.dart';
import './ui/pages/signup_page.dart';

void main() {
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
  late UserCredential result;
  late User user;

  @override

  void initState() {
    super.initState();
  }

  void shouldLogOut() {
    _auth.signOut();
    _google_signin.signOut();
    print('サインアウトしました。');
  }

  // アプリ読み込み時にAmplifyの設定を読み込む
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text("Firebase Chat")),
      body: Container(
          child: user == null ? _buildGoogleSignInButton() : MainPage(shouldLogOut: shouldLogOut, userId: user.uid)),
    );
  }
  
  Widget _buildGoogleSignInButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: RaisedButton(
          child: Text("Google Sign In"),
          onPressed: () async {
            try {
              result = await _auth.signInWithCredential(credential);
              user = result.user!;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(shouldLogOut: shouldLogOut, userId: user.uid),
                )
              );

            } catch (e) {
              print(e);
            }
          },
        )),
      ],
    );
  }
}
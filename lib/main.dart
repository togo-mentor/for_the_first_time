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

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseUser _user;
  final _googleSignIn = new GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  
  Future<FirebaseUser> _handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }

  @override

  void initState() {
    super.initState();
  }

  // アプリ読み込み時にAmplifyの設定を読み込む
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text("Firebase Chat")),
      body: Container(
          child: _user == null ? _buildGoogleSignInButton() : CreateMemoPage()),
    );
  }
  
  Widget _buildGoogleSignInButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: RaisedButton(
          child: Text("Google Sign In"),
          onPressed: () {
            _handleGoogleSignIn().then((user) {
              setState(() {
                _user = user;
              });
            }).catchError((error) {
              print(error);
            });
          },
        )),
      ],
    );
  }
}
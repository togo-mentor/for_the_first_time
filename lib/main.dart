import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
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

  void shouldLogOut() {
    _auth.signOut();
    _google_signin.signOut();
    print('サインアウトしました。');
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: user == null ? _buildGoogleSignInButton() : MainPage(shouldLogOut: shouldLogOut, userId: user!.uid)
    );
  }
  
  Widget _buildGoogleSignInButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: ElevatedButton(
            child: Text("Google Sign In"),
            onPressed: () async {
            try {
              result = await _auth.signInWithCredential(credential);
              user = result!.user;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(shouldLogOut: shouldLogOut, userId: user!.uid),
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
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import './service/auth_service.dart';
import './ui/pages/login_page.dart';
import './ui/pages/main_page.dart';
import './ui/pages/verification_page.dart';
import './ui/pages/signup_page.dart';
import '../amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

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
  final _authService = AuthService();
  @override

  void initState() {
    super.initState();
    _authService.checkAuthStatus();
  }

  // アプリ読み込み時にAmplifyの設定を読み込む
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<AuthState>(
    // 2
    stream: _authService.authStateController.stream,
    builder: (context, snapshot) {
      // 3
      if (snapshot.hasData) {
        return Navigator(
          pages: [
            // Show Login Page
            if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
              MaterialPage(child: LoginPage(shouldShowSignUp: _authService.showSignUp, didProvideCredentials: _authService.loginWithCredentials, key: null,)),
        
            // Show Verification Code Page
            if (snapshot.data!.authFlowStatus == AuthFlowStatus.verification)
            MaterialPage(child: VerificationPage(
              didProvideVerificationCode: _authService.verifyCode)),

            // Show Sign Up Page
            if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
              MaterialPage(child: SignUpPage(shouldShowLogin: _authService.showLogin, didProvideCredentials: _authService.signUpWithCredentials,)),
            
            // Show Main Page
            if (snapshot.data!.authFlowStatus == AuthFlowStatus.session)
              MaterialPage(
                  child: MainPage(shouldLogOut: _authService.logOut))
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      } else {
        // 6
        return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(), // アプリの読み込みが完了しない場合はプログレスバーを表示
        );
      }
    }),
    );
  }
}
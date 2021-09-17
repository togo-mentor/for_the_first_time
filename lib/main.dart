import 'package:flutter/material.dart';
import 'package:for_the_first_time/service/auth_service.dart';
import 'package:for_the_first_time/ui/pages/verification_page.dart';
import 'package:for_the_first_time/ui/pages/signup_page.dart';
import './ui/pages/login_page.dart';
import './ui/pages/main_page.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  @override

  void initState() {
    super.initState();
    _authService.showLogin();
  }

  void _configureAmplify() async {

    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugins([authPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
      print('Successfully configured Amplify 🎉');
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

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
            // 4
            // Show Login Page
            if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
              MaterialPage(child: LoginPage(shouldShowSignUp: _authService.showSignUp, didProvideCredentials: _authService.loginWithCredentials, key: null,)),
        
            // Show Verification Code Page
            if (snapshot.data!.authFlowStatus == AuthFlowStatus.verification)
            MaterialPage(child: VerificationPage(
              didProvideVerificationCode: _authService.verifyCode)),

            // 5
            // Show Sign Up Page
            if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
              MaterialPage(child: SignUpPage(shouldShowLogin: _authService.showLogin, didProvideCredentials: _authService.signUpWithCredentials,))
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      } else {
        // 6
        return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      }
    }),
    );
  }
}
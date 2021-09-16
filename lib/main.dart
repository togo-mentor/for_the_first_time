import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:for_the_first_time/service/auth_service.dart';
import 'package:for_the_first_time/ui/pages/confirm_page.dart';
import 'package:for_the_first_time/ui/pages/confirma_page.dart';
import 'package:for_the_first_time/ui/pages/verification_page.dart';
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

  initState() {
    super.initState(); 
    _configureAmplify(); 
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
      home: Navigator(
        pages: [MaterialPage(child: LoginPage())],
        onPopPage: (route, result) => route.didPop(result),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/confirm') {
          return PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              ConfirmPage(data: settings.arguments as LoginData),
          transitionsBuilder: (_, __, ___, child) => child,
        );
      }
    )
  }
}
import 'package:flutter/material.dart';
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
      home: LoginPage(),
    );
  }
}
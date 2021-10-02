import 'package:flutter/material.dart';
import './service/auth_service.dart';
import './ui/pages/login_page.dart';
import './ui/pages/main_page.dart';
import './ui/pages/verification_page.dart';
import './ui/pages/signup_page.dart';

void main() => runApp(MyApp());
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
    
    );
  }
}
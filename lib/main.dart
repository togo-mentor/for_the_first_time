import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:for_the_first_time/ui/pages/main_page.dart';
import './ui/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'models/auth.dart';

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
    // print(RegExp(r'^(?=.*?[a-z])(?=.*?[\d])[a-z\d]+$').hasMatch('test1234'));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MaterialApp(
        home: _LoginCheck(),
        builder: EasyLoading.init(),
      )
    );
  }
}

// 新たに追加
class _LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _loggedIn = context.watch<Auth>().loggedIn;
    print(_loggedIn);
    // ログイン状態に応じて、画面を切り替える
    return _loggedIn ? confirmCheck(context) : LoginPage();
  }

  Widget confirmCheck(BuildContext context) {
    final bool _confirmed = context.watch<Auth>().confirmed;
    print(_confirmed);
    if (_confirmed) {
      return MainPage();
    } else {
      return Container();
    }
  }
}
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import '../../amplifyconfiguration.dart';
import './tab_page.dart';
import './create_memo_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final _tab = <Tab> [  // タブバーの表示
    Tab(text:"記録する", icon: Icon(Icons.note_add)),
    Tab(text:"履歴を見る", icon: Icon(Icons.history)),
    Tab(text:"ダッシュボード", icon: Icon(Icons.dashboard)),
  ];

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
    return DefaultTabController(  // タブを制御
      length: _tab.length,  // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text("はじめて図鑑"),
          bottom: TabBar(  // タブバー
            tabs: _tab,
            labelPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
          ),
        ),
        body: TabBarView(  // 表示画面のウィジェット一覧を渡す
            children: <Widget> [
              CreateMemoPage(),
              TabPage(title: "履歴を見る", icon: Icons.history),
              TabPage(title: "ダッシュボード", icon: Icons.dashboard),
            ]
        ),
      ),
    );
  }
}
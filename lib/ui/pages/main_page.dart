import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/auth.dart';
import './create_memo_page.dart';
import 'app_info_page.dart';
import 'dashboard_page.dart';
import 'memo_history.page.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(  // タブを制御
      length: _tab.length,  // タブの数
      child: Scaffold(
        drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("ホーム"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => MainPage(),
                ));
              }
            ),
            ListTile(
              title: Text("アプリ情報"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => AppInfoPage(),
                ));
              }
            ),
          ],
        )),
        appBar: AppBar(
          title: Text("はじめて図鑑"),
          actions: <Widget>[
            TextButton(
              child: Icon(Icons.logout), 
              onPressed: () async {
                try {
                  await context.read<Auth>().logout();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('ログアウトに失敗しました。もう一度お試しください。'),
                  ));
                }
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            )
          ],
          bottom: TabBar(  // タブバー
            tabs: _tab,
            labelPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
          ),
        ),
        body: TabBarView(  // 表示画面のウィジェット一覧を渡す
            children: <Widget> [
              CreateMemoPage(),
              MemoHistoryPage(),
              DashBoardPage(),
            ]
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import './tab_page.dart';
import './create_memo_page.dart';

class MainPage extends StatefulWidget {
  final VoidCallback shouldLogOut;
  MainPage({Key? key, required this.shouldLogOut})
   : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _tab = <Tab> [  // タブバーの表示
    Tab(text:"記録する", icon: Icon(Icons.note_add)),
    Tab(text:"履歴を見る", icon: Icon(Icons.history)),
    Tab(text:"ダッシュボード", icon: Icon(Icons.dashboard)),
  ];

  Widget build(BuildContext context) {
    return DefaultTabController(  // タブを制御
      length: _tab.length,  // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: Text("はじめて図鑑"),
          actions: <Widget>[
            TextButton(
              child: Icon(Icons.logout), 
              onPressed: widget.shouldLogOut,
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
              TabPage(title: "履歴を見る", icon: Icons.history),
              TabPage(title: "ダッシュボード", icon: Icons.dashboard),
            ]
        ),
      ),
    );
  }
}
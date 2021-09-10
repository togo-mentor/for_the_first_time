import 'package:flutter/material.dart';

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
              TabPage(title: "記録する", icon: Icons.note_add),
              TabPage(title: "履歴を見る", icon: Icons.history),
              TabPage(title: "ダッシュボード", icon: Icons.dashboard),
            ]
        ),
      ),
    );
  }
}

class TabPage extends StatelessWidget {

  final IconData icon;
  final String title;

  const TabPage({key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.headline4;  // 文字のスタイル
    return Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 72.0, color: textStyle!.color),
          Text(title, style: textStyle),
        ],
      ),
    );
  }
}
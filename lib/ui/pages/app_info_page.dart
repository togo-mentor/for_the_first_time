import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/auth.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

class AppInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/icon.png'),
              Text('はじめて図鑑')
            ]
          )
        )
      );
  }
}
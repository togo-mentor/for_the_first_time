import 'package:flutter/material.dart';

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
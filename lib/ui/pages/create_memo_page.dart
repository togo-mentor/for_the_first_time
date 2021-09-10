import 'package:flutter/material.dart';

class CreateMemoPage extends StatefulWidget {
  @override
  _CreateMemoPageState createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {

  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '名前',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: '趣味',
              ),
            ),
            ElevatedButton(
              child: Text('新規登録'),
              onPressed: () {
                // TODO: 新規登録
              },
            ),
          ],
        ),
    );
  }
}

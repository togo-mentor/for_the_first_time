import 'package:flutter/material.dart';

class CreateMemoPage extends StatefulWidget {
  @override
  _CreateMemoPageState createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
          children: [
            Text (
              '今日あった「人生初」を記録しよう',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
            Form (
              child: Column (
                children: <Widget>[
                  TextFormField (
                    decoration: InputDecoration(
                      hintText: '出来事',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'このフィールドは必須です';
                      }
                    },
                    autofocus: true,
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
                ]
              )
            ),
          ],
        ),
    );
  }
}

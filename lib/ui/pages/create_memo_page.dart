import 'package:flutter/material.dart';

class CreateMemoPage extends StatefulWidget {
  @override
  _CreateMemoPageState createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  String dropdownValue = '食';
  List<String> genreList = ['食', '運動', '自然', '勉強', '読書', '旅'];

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
                      hintText: '今日あった「人生初」の出来事を記録してください',
                      labelText: "出来事",
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'このフィールドは必須です';
                      }
                    },
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                  ),
                  DropdownButtonFormField<String>(
                  value: dropdownValue,
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                   decoration: InputDecoration(
                    labelText: 'ジャンル',
                  ),
                  items: genreList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    child: Text('保存する'),
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

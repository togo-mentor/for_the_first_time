import 'package:flutter/material.dart';

class Genre {
  final int id;
  final String name;

  Genre(this.id, this.name);
}

class CreateMemoPage extends StatefulWidget {
  @override
  _CreateMemoPageState createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  String _event = '';
  List<Genre> genreList = <Genre>[
    Genre(1, '食'),
    Genre(2, '運動'),
    Genre(3, '自然'),
    Genre(4, '勉強'),
    Genre(5, '読書'),
    Genre(6, '旅'),
  ];
  Genre genre = Genre(0, '');
  bool _selected = false;

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
            SizedBox(
              height: 30,
            ),
            Form (
              child: Column (
                children: <Widget>[
                  TextFormField (
                    decoration: InputDecoration(
                      hintText: '今日あった「人生初」の出来事を記録してください',
                      labelText: "出来事",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior:FloatingLabelBehavior.always, // labelを上部に固定
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'このフィールドは必須です';
                      }
                    },
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    onSaved: (value) {
                      _event = value!;
                    },
                  ),
                  SizedBox(
				            height: 20,
                  ),
                  DropdownButtonFormField<Genre>(
                  value: _selected ? genre : null,
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (Genre? newValue) {
                    setState(() {
                      genre = newValue!;
                    });
                  },
                  validator: (Genre? value) {
                      if (value == null) {
                        return 'このフィールドは必須です';
                      }
                    },
                   decoration: InputDecoration(
                    labelText: 'ジャンルを選択',
                    border: OutlineInputBorder(),
                  ),
                  items: genreList
                        .map<DropdownMenuItem<Genre>>((Genre item) {
                      return DropdownMenuItem<Genre>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                  ),
                  SizedBox(
				            height: 25,
                  ),
                  ElevatedButton(
                    child: Text('保存する'),
                    onPressed: () {
                      // TODO: メモの保存処理を書く
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 70, vertical: 15)),
                    ),
                  ),
                ]
              )
            ),
          ],
        ),
    );
  }
}

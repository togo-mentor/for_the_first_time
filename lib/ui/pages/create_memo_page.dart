import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:for_the_first_time/models/genre.dart';
import '../../models/post.dart';
import 'package:http/http.dart' as http;

class CreateMemoPage extends StatefulWidget {
  @override
  _CreateMemoPageState createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  
  GlobalKey<FormState> _formKeyScreen1 = GlobalKey<FormState>();
  String content = '';
  Genre genre = Genre(0, '');
  bool _selected = false;

  void initState() {
    super.initState();
  }

  Future _createPost(content, genreId) async {
    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String identityId = (res as CognitoAuthSession).identityId!; // 一旦cognitoのユーザー情報をDBに保存する
      Post newPost = new Post(content: content, genreId: genreId, userToken: identityId);
      String url = 'http://127.0.0.1:3000/posts';
      final response = await http.post(Uri.parse(url),
        body: json.encode(newPost.toJson()),
        headers: {"Content-Type": "application/json"}
      );
      if (response.statusCode == 200) {
        _formKeyScreen1.currentState?.reset(); // フォームの入力内容をリセット
        content = '';
        _selected = false;
      }
    } catch (error) {
      print(error);
    }
  }

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
              key: _formKeyScreen1,
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
                    onChanged: (value) {
                      content = value;
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
                      _createPost(content, genre.id);
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

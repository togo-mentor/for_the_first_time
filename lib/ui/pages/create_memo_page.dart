import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:for_the_first_time/models/genre.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../models/post.dart';
import 'package:http/http.dart' as http;

class CreateMemoPage extends StatefulWidget {
  @override
  _CreateMemoPageState createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  //  final fieldText = TextEditingController();
  String content = '';
  Genre genre = Genre(0, '');
    FormGroup form = FormGroup({
    'content': FormControl<String>(
      validators: [
        Validators.required,
      ],
    ),
    'genreId': FormControl<Genre>(validators: [
      Validators.required,
    ]),
  });

  @override
  void initState() {
    super.initState();
  }

  Future _createPost(content, genreId) async {
    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String identityId = (res as CognitoAuthSession).identityId!; // 一旦cognitoのユーザー情報をDBに保存する
      Post newPost = Post(content: content, genreId: genreId, userToken: identityId);
      String url = 'http://127.0.0.1:3000/posts';
      final response = await http.post(Uri.parse(url),
        body: json.encode(newPost.toJson()),
        headers: {"Content-Type": "application/json"}
      );
      if (response.statusCode == 200) {
        form.control('content').value = '';
        form.control('genreId').value = null;
        form.unfocus(touched: false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('保存に成功しました！'),
        ));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
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
            ReactiveForm(
            formGroup: form,
            child: Column(
              children: <Widget>[
                ReactiveTextField(
                    formControlName: 'content',
                    maxLines: 10,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '今日あった「人生初」の出来事を記録してください',
                      labelText: "出来事",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior:FloatingLabelBehavior.always, // labelを上部に固定
                    ),
                    validationMessages: (control) => {
                      ValidationMessage.required: '出来事を入力してください。',
                    },
                  ),
                  SizedBox(
				            height: 20,
                  ),
                  ReactiveDropdownField(
                    iconSize: 24,
                    elevation: 16,
                    formControlName: 'genreId',
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
                      form.valid ? _createPost(form.control('content').value, form.control('genreId').value.id) : null;
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 70, vertical: 15)),
                    ),
                  ),
                ]
              ),
            )
          ],
        ),
    );
  }
}

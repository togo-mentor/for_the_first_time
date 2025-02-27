import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/genre.dart';
import 'package:for_the_first_time/service/post_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../models/post.dart';

class CreateMemoPage extends StatefulWidget {
  @override
  _CreateMemoPageState createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
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
      Post newPost = Post(content: content, genreId: genreId);
      await PostService().createPost(newPost);
      // フォームの入力値のリセット
      form.control('content').value = '';
      form.control('genreId').value = null;
      form.unfocus(touched: false); // 保存後にバリデーションメッセージが出てくるのを防ぐためにfocusを外す
      // 画面下部にフラッシュメッセージを表示
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('保存に成功しました！'),
      ));
    } catch (error) {
      print(error);
    }
  }

  // バリデーションメッセージを表示
  void showValidationMessage() {
    form.control('content').markAsTouched();
    form.control('genreId').markAsTouched();
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
              height: 20,
            ),
            ReactiveForm(
            formGroup: form,
            child: Column(
              children: <Widget>[
                ReactiveTextField(
                    formControlName: 'content',
                    maxLines: 8,
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
                    validationMessages: (control) => {
                      ValidationMessage.required: 'ジャンルを選択してください。',
                    },
                  ),
                  SizedBox(
				            height: 20,
                  ),
                  ElevatedButton(
                    child: Text('保存する'),
                    onPressed: () {
                      form.valid ? _createPost(form.control('content').value, form.control('genreId').value.id) : showValidationMessage();
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

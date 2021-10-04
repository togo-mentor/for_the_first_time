import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:for_the_first_time/models/auth.dart';
import 'package:for_the_first_time/support/firebase_auth_error.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Firebase Authenticationを利用するためのインスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  static const passwordPattern = r'^(?=.*?[a-zA-Z])(?=.*?\d])[a-zA-Z\d]$';
  FormGroup form = FormGroup({
    'password': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(8),
        Validators.maxLength(20),
        Validators.pattern(passwordPattern)
      ],
    ),
    'email': FormControl<String>(
      validators: [
        Validators.required,
        Validators.email,
      ],
    )
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ReactiveForm(
                  formGroup: form,
                  child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                      child: ReactiveTextField(
                        formControlName: 'email',
                        decoration: InputDecoration(
                          labelText: "メールアドレス"
                        ),
                        validationMessages: (control) => {
                          ValidationMessage.required: 'メールアドレスを入力してください。',
                          ValidationMessage.email: 'メールアドレスの形式が不正です。',
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                      child: ReactiveTextField(
                        formControlName: 'password',
                        decoration: InputDecoration(
                          labelText: "パスワード（8～20文字）"
                        ),
                        obscureText: true,  // パスワードが見えないようRにする
                        maxLength: 20,  // 入力可能な文字数
                        validationMessages: (control) => {
                          ValidationMessage.required: 'パスワードを入力してください。',
                          ValidationMessage.minLength: 'パスワードは最低8文字必要です',
                          ValidationMessage.maxLength: 'パスワードは最大20文字までです',
                          ValidationMessage.pattern: 'パスワードは半角英数字混合で設定してください',
                        },
                      ),
                    ),                  
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonTheme(
                      minWidth: 350.0,
                      child: SizedBox(
                      width: 300,
                      child: 
                        ElevatedButton(
                          onPressed: () async {
                            if (form.valid) {
                              try {
                                // メール/パスワードでユーザー登録
                                await _signUp(context);
                                Navigator.of(context).pop();
                              } on FirebaseAuthException catch (e) {
                                  // ログインに失敗した場合
                                  FirebaseAuthResultStatus resultStatus = FirebaseAuthExceptionHandler.handleException(e);
                                  final errorMessage = FirebaseAuthExceptionHandler.exceptionMessage(resultStatus);
                                  EasyLoading.dismiss();
                                  _showErrorDialog(context, errorMessage);
                              }
                            } else {
                              showValidationMessage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                          // ボタン内の文字や書式
                          child: Text('登録する',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                    ),
                  )
                )
              ]
            ),
            )
          ]
        ), // 画面下にボタンの配置
      ),
      bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child:ButtonTheme(
                  minWidth: 350.0,
                  // height: 100.0,
                  child: ElevatedButton(
                    child: Text('アカウントをお持ちの方はこちらからログイン',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[50],
                    ),

                    // ボタンクリック後にアカウント作成用の画面の遷移する。
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => LoginPage(),
                        ),
                      );
                    }

                  ),
                ),
              ),
            ]
          )
    );
  }

  // バリデーションメッセージを表示
  void showValidationMessage() {
    form.control('password').markAsTouched();
    form.control('email').markAsTouched();
  }

  Future<bool> _signUp(BuildContext context) async {
    bool loggedIn = false;
    EasyLoading.show(status: 'loading...');
    if (await context.read<Auth>().signUp(
      form.control('email').value,
      form.control('password').value,
    )) {
      loggedIn = true;
    }
    EasyLoading.dismiss();
    return loggedIn;
  }

  void _showErrorDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(message!),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}
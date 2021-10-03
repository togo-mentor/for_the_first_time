import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/ui/pages/signup_page.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  final void handleAuthStateChange;
  LoginPage({Key? key, this.handleAuthStateChange}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Firebase Authenticationを利用するためのインスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? _result;
  User? _user;
  FormGroup form = FormGroup({
    'password': FormControl<String>(
      validators: [
        Validators.required,
      ],
    ),
    'email': FormControl<String>(
      validators: [
        Validators.required,
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
                            try {
                              // メール/パスワードでユーザー登録
                              _result = await auth.signInWithEmailAndPassword(
                                email: form.control('email').value,
                                password: form.control('password').value,
                              );

                              // ログイン成功
                              // ログインユーザーのIDを取得
                              _user = _result!.user;
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => MainPage(userId: _user!.uid),
                              //   )
                              // );
                              
                            } catch (e) {
                              // ログインに失敗した場合
                              setState(() {
                                print(e);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                          // ボタン内の文字や書式
                          child: Text('ログイン',
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
                    child: Text('アカウントを作成する',
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
                          builder: (BuildContext context) => SignUpPage(),
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
}
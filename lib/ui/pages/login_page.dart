import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/ui/pages/signup_page.dart';
import '../../service/auth_credentials.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _login_Email = "";  // 入力されたメールアドレス
  String _login_Password = "";  // 入力されたパスワード
  String _infoText = "";  // ログインに関する情報を表示

  // Firebase Authenticationを利用するためのインスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  AuthResult? _result;
  FirebaseUser? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // メールアドレスの入力フォーム
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child:TextFormField(
                    decoration: InputDecoration(
                      labelText: "メールアドレス"
                    ),
                    onChanged: (String value) {
                      _login_Email = value;
                    },
                  )
                ),

                // パスワードの入力フォーム
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                  child:TextFormField(
                    decoration: InputDecoration(
                      labelText: "パスワード（8～20文字）"
                    ),
                    obscureText: true,  // パスワードが見えないようRにする
                    maxLength: 20,  // 入力可能な文字数
                    maxLengthEnforced: false,  // 入力可能な文字数の制限を超える場合の挙動の制御
                    onChanged: (String value) {
                      _login_Password= value;
                    },
                  ),
                ),

                // ログイン失敗時のエラーメッセージ
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                  child:Text(_infoText,
                    style: TextStyle(color: Colors.red),),
                ),

                ButtonTheme(
                  minWidth: 350.0,
                  // height: 100.0,
                  child: RaisedButton(

                    // ボタンの形状
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    onPressed: () async {
                      try {
                        // メール/パスワードでユーザー登録
                        _result = await auth.signInWithEmailAndPassword(
                          email: _login_Email,
                          password: _login_Password,
                        );

                        // ログイン成功
                        // ログインユーザーのIDを取得
                        _user = _result!.user;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(),
                          )
                        );
                        
                      } catch (e) {
                        // ログインに失敗した場合
                        setState(() {
                          print(e);
                        });
                      }
                    },

                    // ボタン内の文字や書式
                    child: Text('ログイン',
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    textColor: Colors.white,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
        // 画面下にボタンの配置
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child:ButtonTheme(
                minWidth: 350.0,
                // height: 100.0,
                child: RaisedButton(
                  child: Text('アカウントを作成する',
                  style: TextStyle(fontWeight: FontWeight.bold),),
                  textColor: Colors.blue,
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:for_the_first_time/models/auth.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class VerificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 40),
        child: _verificationForm(context),
      ),
    );
  }

  void showProgressDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 500),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  Widget _verificationForm(BuildContext context) {
    final user = context.read<Auth>().user;
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('メールアドレスの認証が完了しておりません。',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
          Text('${user!.email}に送信されたメールのリンクをクリックして認証を完了させてください。',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ButtonTheme(
            minWidth: 200.0,  
            child: ElevatedButton(
              onPressed: () async {
                await _resendVerificationEmail(context);
              },
              // ボタン内の文字や書式
              child: Text('確認メールを再送信',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ButtonTheme(
            minWidth: 200.0,  
            child: ElevatedButton(
              onPressed: () async {
                context.read<Auth>().logout();
              },
              // ボタン内の文字や書式
              child: Text('ログインページに戻る',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
          ),
        ],
      )
    );
  }

  Future<bool> _resendVerificationEmail(BuildContext context) async {
    bool loggedIn = false;
    EasyLoading.show(status: 'loading...');
    final user = context.read<Auth>().user;
    await user!.sendEmailVerification();
    EasyLoading.dismiss();
    // 画面下部にフラッシュメッセージを表示
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${user.email}宛に確認のメールを送信しました。メール内のリンクから認証を完了させてください。'),
    ));
    return loggedIn;
  }
}
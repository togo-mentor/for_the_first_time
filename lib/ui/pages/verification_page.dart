import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:for_the_first_time/models/auth.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 40),
        child: _verificationForm(),
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

  Widget _verificationForm() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        ],
      )
    );
  }

  Future<bool> _resendVerificationEmail(BuildContext context) async {
    bool loggedIn = false;
    EasyLoading.show(status: 'loading...');
    // print(context.read<Auth>().user);
    await context.read<Auth>().user!.sendEmailVerification();
    EasyLoading.dismiss();
    return loggedIn;
  }
}
import 'package:flushbar/flushbar.dart';
import 'auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordForm extends StatefulWidget {
  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {

  final AuthService _auth = AuthService();
  final _formGlobalKey = GlobalKey<FormState>();
  String _email = '';

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('パスワードリセット画面'),
      ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("パスワード再設定メールを送信",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'メールアドレス'),
                    onChanged: (String value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.only(top: 15, right: 75, left: 75, bottom: 15),
                    child: Text('メールを送信',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    onPressed: () async {
//                  if (_formGlobalKey.currentState.validate()) {

                      String _result = await _auth.sendPasswordResetEmail(_email);

                      // 成功時は戻る
                      if (_result == 'success') {
                        Navigator.pop(context);
                      } else if (_result == 'ERROR_INVALID_EMAIL') {
                        Flushbar(
                          message: "無効なメールアドレスです",
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      } else if (_result == 'ERROR_USER_NOT_FOUND') {
                        Flushbar(
                          message: "メールアドレスが登録されていません",
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      } else {
                        Flushbar(
                          message: "メール送信に失敗しました",
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      }
//                  }
                    },
                  ),
                ],
              ),
            ),
          )
        ),
    );

  }
}
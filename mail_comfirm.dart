import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


class Email extends StatefulWidget {
  final auth.User user;
  const Email({@required this.user, Key key}) : super(key: key);
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('仮登録画面'),
      ),
      body: Container(
        padding: EdgeInsets.all(44),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("メールを送信しました。",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Text("まだ仮登録の状態ですので、受信したメールのURLから本登録を完了させてください。"),
              OutlineButton(
                child: Text("ログイン画面に戻る"),
                color: Colors.blue,
                onPressed: () async{
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return UserLogin();
                    }),
                  );
                },
              ),
              RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                shape: StadiumBorder(),
                child: Text('再送信'),
                onPressed: ()async{
                  await widget.user.sendEmailVerification();
                  return Flushbar(
                    message: "再送信しました",
                    backgroundColor: Colors.green,
                    margin: EdgeInsets.all(8),
                    borderRadius: 8,
                    duration: Duration(seconds: 3),
                  )..show(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


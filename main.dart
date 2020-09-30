import 'package:flutter/material.dart';
import 'flutter_calendar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_situation.dart';
import 'reset_password_form.dart';
import 'mail_comfirm.dart';
import 'information.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'privacy_policy.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
//import 'staff.dart';

Future<bool> _shouldUpdate() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final appVersionStr = packageInfo.version;
  final appVersion = Version.parse(appVersionStr); // 現在のアプリのバージョン

  // remoteConfigの初期化
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  // 何らかの事情でRemoteConfigから最新の値を取ってこれなかった場合のフォールバック
  final defaultValues = <String, dynamic>{
    'android_required_semver': appVersionStr,
    'ios_required_semver': appVersionStr
  };
  await remoteConfig.setDefaults(defaultValues);

  await remoteConfig.fetch(); // デフォルトで12時間キャッシュされる
  await remoteConfig.activateFetched();

  final remoteConfigAppVersionKey =
  Platform.isIOS ? 'ios_required_semver' : 'android_required_semver'; // iOSとAndroid以外のデバイスが存在しない世界線での実装
  final requiredVersion = Version.parse(remoteConfig.getString(remoteConfigAppVersionKey));
  return appVersion.compareTo(requiredVersion).isNegative;
}


_launchURL() async {
  const url = "http://https://www.google.co.jp/";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not Launch $url';
  }
}


main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //向き指定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,//縦固定
  ]);

  try {
    if (await _shouldUpdate()) {
      runApp(new appDate());
    }else{
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        runApp(new User());
      }
    }
  } on SocketException catch (_) {
    print('not connected');
    runApp(new Offline());
  }

}

class appDate extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final UserState userState = UserState();

    return ChangeNotifierProvider<UserState>.value(
      value: userState,
      child: MaterialApp(
        // 右上に表示される"debug"ラベルを消す
        debugShowCheckedModeBanner: false,
        // アプリ名
        title: 'ChatApp',
        theme: ThemeData(
          // テーマカラー
          primarySwatch: Colors.lightGreen,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ログイン画面を表示
        home: AppDate(),
      ),
    );
  }
}

class AppDate extends StatefulWidget {
  @override
  _AppDateState createState() => _AppDateState();
}

class _AppDateState extends State<AppDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Container(
        child: Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            title: Text('バージョン更新のお知らせ',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
            content: Text("新しいバージョンのアプリが公開されていますので、ストアから更新版を入手してください。"),
            actions: <Widget>[
              FlatButton(
                child: Text("今すぐ更新",style: TextStyle(color: Colors.red),),
                onPressed: () {
                  _launchURL();
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Offline extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final UserState userState = UserState();

    return ChangeNotifierProvider<UserState>.value(
      value: userState,
      child: MaterialApp(
        // 右上に表示される"debug"ラベルを消す
        debugShowCheckedModeBanner: false,
        // アプリ名
        title: 'ChatApp',
        theme: ThemeData(
          // テーマカラー
          primarySwatch: Colors.lightGreen,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ログイン画面を表示
        home: OffLine(),
      ),
    );
  }
}

class OffLine extends StatefulWidget {
  @override
  _OffLineState createState() => _OffLineState();
}

class _OffLineState extends State<OffLine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('インターネットに接続してください',style: TextStyle(fontWeight: FontWeight.bold),),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              RaisedButton(
                child: Text('再試行'),
                onPressed: (){
                  return main();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}





class UserState extends ChangeNotifier {
  auth.User user;
  void setUser(auth.User newUser) {
    user = newUser;
//    notifyListeners();
  }
}




class User extends StatelessWidget {


  final UserState userState = UserState();
  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider<UserState>.value(
      value: userState,
      child: MaterialApp(
        // 右上に表示される"debug"ラベルを消す
        debugShowCheckedModeBanner: false,
        // アプリ名
        title: 'ChatApp',
        theme: ThemeData(
          // テーマカラー
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ログイン画面を表示
        home: LandingPage(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);

    return StreamBuilder<auth.User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          auth.User user = snapshot.data;

          if (user == null) {
            return UserLogin();
          }else{
            if (user.emailVerified) {
              userState.setUser(user);
              return CalendarViewApp();
            }else{
              return UserLogin();
            }

          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}





class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {






  String infoText = '';

  String name = '';
  String tel = '';
  String email = '';
  String password = '';
  bool change = false;
  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        content: new Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(50),
            ),
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green))
          ],
        ),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){

          return Container(
            height: 400,
            width: 400,
            child: alert,
          );
        },
      );
    }
    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン画面', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,


      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'メールアドレス'),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'パスワード'),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                OutlineButton(
                  child: Text("パスワードを忘れた方"),
                  color: Colors.blue,
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ResetPasswordForm();
                      }),
                    );
                  },
                ),
                OutlineButton(
                  child: Text("初めての方はこちら"),
                  color: Colors.blue,
                  onPressed: () async {
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return UserRegistration();
                      }),
                    );
                  },
                ),
                Container(
                  width: double.infinity,

                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      RaisedButton(
                        color: Colors.lightGreen,
                        textColor: Colors.white,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.only(top: 15, right: 75, left: 75, bottom: 15),
                        child: Text('ログイン',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        onPressed: () async {

                          showAlertDialog(context);

                          try {
                            final result = await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                              print('connected');
                              try {
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final UserCredential result = await auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );


                                if (result.user.emailVerified) {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  final user = result.user;
                                  userState.setUser(user);
                                  await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return CalendarViewApp();
                                    }),
                                  );

                                } else {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text("【メールアドレスの確認が完了していません。】"),
//                                      content: Text("その時間はすでに予約されています。"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("OK"),
                                              onPressed: () =>
                                                  Navigator.of(context, rootNavigator: true).pop(),
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }

                              } catch (e) {
                                Navigator.of(context, rootNavigator: true).pop();
                                setState(() {
                                  infoText = "ログインに失敗しました : ${e.message}";
                                });
                              }
                            }else{
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          } on SocketException catch (_) {
                            print('not connected');
                            Navigator.of(context, rootNavigator: true).pop();
                            Flushbar(
                              message: "インターネットに接続されていません",
                              backgroundColor: Colors.red,
                              margin: EdgeInsets.all(8),
                              borderRadius: 8,
                              duration: Duration(seconds: 3),
                            )..show(context);
                          }



                        },

                      ),


                    ],
                  ),
                ),
                Text(infoText),
              ]
          ),
        ),
      ),
    );
  }
}

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {

  String infoText = '';

  String firstName = '';
  String lastName = '';
  String tel = '';
  String _phoneNumberValidator(String value) {
    Pattern pattern =
        r'/^\d{10}$|^\d{11}$/';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Phone Number';
    else
      return null;
  }
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  bool _flag = false;

  void _handleCheckbox(bool e) {
    setState(() {
      _flag = e;
    });
  }
  @override
  Widget build(BuildContext context) {

    showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        content: new Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(50),
            ),
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green))
          ],
        ),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){

          return Container(
            height: 400,
            width: 400,
            child: alert,
          );
        },
      );
    }

    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザー登録画面',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          enabled: true,
                          maxLengthEnforced: false,
                          obscureText: false,
                          autovalidate: false,
                          decoration: InputDecoration(labelText: '姓'),
                          validator: (String value) {
                            return value.isEmpty ? '必須入力です' : null;
                          },
                          onSaved: (String value) {
                            this.lastName = value;
                          },
                        ),
                      ),

                      Flexible(
                        child: TextFormField(
                          enabled: true,
                          maxLengthEnforced: false,
                          obscureText: false,
                          autovalidate: false,
                          decoration: InputDecoration(labelText: '名'),
                          validator: (String value) {
                            return value.isEmpty ? '必須入力です' : null;
                          },
                          onSaved: (String value) {
                            this.firstName = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    autovalidate: false,
                    decoration: InputDecoration(labelText: '携帯電話番号(ハイフンあり)',hintText: "例:090-0000-0000"),
//                    onChanged: (String value) {
//                      setState(() {
//                        tel = value;
//                      });
//                    },
                    validator: (String value) {
                      bool result = new RegExp(r'^0[789]0-[0-9]{4}-[0-9]{4}$').hasMatch(value);
                      return !result ? '携帯電話番号をハイフンをつけて入力してください。' : null;
                    },
                    onSaved: (String value) {
                      this.tel = value;
                    },

                  ),
                  TextFormField(
                    autovalidate: false,
                    decoration: InputDecoration(labelText: 'メールアドレス'),
                    validator: (String value) {
                      return value.isEmpty ? '必須入力です' : null;
                    },
                    onSaved: (String value) {
                      this.email = value;
                    },
                  ),
                  TextFormField(
                    autovalidate: false,
                    decoration: InputDecoration(labelText: 'パスワード'),
                    obscureText: true,
                    validator: (String value) {
                      return value.isEmpty ? '必須入力です' : null;
                    },
                    onSaved: (String value) {
                      this.password = value;
                    },
                  ),
                  OutlineButton(
                    child: Text("既にアカウントをお持ちの方はこちら"),
                    color: Colors.blue,
                    onPressed: () async{
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return UserLogin();
                        }),
                      );
                    },
                  ),
                  Container(
                    width: double.infinity,

                    child: Column(
                      children: <Widget>[
//                        Padding(
//                          padding: EdgeInsets.all(10.0),
//                        ),
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          textColor: Colors.blueGrey,
                          child: Text("プライバシーポリシー"),
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return Privacy();
                              }),
                            );
                          },
                        ),

                        Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: Colors.green,
                              value: _flag,
                              onChanged: _handleCheckbox,
                            ),
                            Text("プライバシーポリシーに同意しますか？"),
                          ],
                        ),

                        _flag ? RaisedButton(
                          color: Colors.lightGreen,
                          textColor: Colors.white,
                          padding: EdgeInsets.only(top: 15, right: 75, left: 75, bottom: 15),
                          shape: StadiumBorder(),
                          child: Text('ユーザー登録',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          onPressed: () async {
                            showAlertDialog(context);

                            try {
                              final result = await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                print('connected');
                                if (this._formKey.currentState.validate()) {
                                  this._formKey.currentState.save();


                                  try {





                                    if(email != ""){

                                      final FirebaseAuth auth = FirebaseAuth.instance;
                                      final UserCredential result = await auth.createUserWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );

                                      Navigator.of(context, rootNavigator: true).pop();
                                      Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                          return Email(user: result.user);
                                        }),
                                      );

                                      await result.user.sendEmailVerification();
                                      await FirebaseFirestore.instance.collection("user_information").doc(result.user.uid).set({
                                        "firstName": firstName,
                                        "lastName": lastName,
                                        "tel": tel,
                                      }).then((val) {
                                        print("成功です");
                                      }).catchError((err) {
                                        print(err);
                                      });

                                    }


//                            result.user.sendEmailVerification().then((val) async{
//                              print("成功");
//                            }).catchError((error) {
//                              print(error);
//                          });




                                  } catch (e) {

                                    setState(() {
                                      if(email == ""){
                                        infoText = "登録に失敗しました : メールアドレスを入力してください。";
                                      }
                                      infoText = "登録に失敗しました : ${e.message}";
                                    });
                                  }
                                }else{
                                  Navigator.of(context, rootNavigator: true).pop();
                                }
                              }
                            } on SocketException catch (_) {
                              print('not connected');
                              Navigator.of(context, rootNavigator: true).pop();
                              Flushbar(
                                message: "インターネットに接続されていません",
                                backgroundColor: Colors.red,
                                margin: EdgeInsets.all(8),
                                borderRadius: 8,
                                duration: Duration(seconds: 3),
                              )..show(context);
                            }





                          },

                        ):RaisedButton(
                          color: Colors.grey,
                          textColor: Colors.white,
                          padding: EdgeInsets.only(top: 15, right: 75, left: 75, bottom: 15),
                          shape: StadiumBorder(),
                          child: Text('ユーザー登録',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          onPressed: (){

                          },

                        )

                      ],
                    ),
                  ),
                  Text(infoText),
                ]
            ),
          ),
        ),
      )
    );
  }
}

class CalendarViewApp extends StatelessWidget {
  void handleNewDate(date) {
    print("handleNewDate ${date}");
  }



  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'vamboo',
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        fontFamily: 'GenJyuuGothic2'
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {



  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final auth.User user = userState.user;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('vamboo',style: TextStyle(fontSize: 30,fontFamily: 'Pacifico'),),
      ),
      drawer: Drawer(
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(user.email,style: TextStyle(color: Colors.white),),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text('予約状況確認'),
              onTap: () async{
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return BookingSituation();
                  }),
                );
              },
            ),
//            ListTile(
//              title: Text('スタッフ情報'),
//              onTap: () async{
//                await Navigator.of(context).push(
//                  MaterialPageRoute(builder: (context) {
//                    return StaffMember();
//                  }),
//                );
//              },
//            ),
            ListTile(
              title: Text('店舗情報'),
              onTap: () async{
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return InformationInformation();
                  }),
                );
              },
            ),
            ListTile(
              title: Text('プライバシーポリシー'),
              onTap: () async{
                await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return Privacy();
                  }),
                );
              },
            ),

            ListTile(
              title: Text('ログアウト',style: TextStyle(color: Colors.red),),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: Text("ログアウトしますか？"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("キャンセル"),
                            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                          ),
                          FlatButton(
                            child: Text("ログアウトする", style: TextStyle(color: Colors.red),),
                            onPressed: () async{
                              Navigator.of(context, rootNavigator: true).pop();
                              await auth.FirebaseAuth.instance.signOut();
                              await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                                  return User();
                                }),
                              );

                            }
                          ),
                        ],
                      );
                    }
                );

              },
            ),
          ],
        ),
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            Calendar(
              onSelectedRangeChange: (range) =>
                  print("Range is ${range.item1}, ${range.item2}"),
              isExpandable: true,
            )
          ],
        ),
      ),
    );
  }
}

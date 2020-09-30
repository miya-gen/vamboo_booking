import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flushbar/flushbar.dart';
import 'package:mailer/mailer.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;




class Confirm extends StatefulWidget {
  final DateTime dayData;
  final int i;
  const Confirm({@required this.dayData, this.i, Key key}) : super(key: key);


  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  List<String> timeList = [
    ' 9:00',
    ' 9:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00'
  ];


  String _type = '';

  void _handleRadio(String e) =>
      setState(() {
        _type = e;
      });

  String _change(String e) {
    String set = "";
    switch (e) {
      case 'cut':
        set = "cut";
        break;
      case 'color':
        set = "color";
        break;
      case 'perm':
        set = "perm";
        break;
      case 'sp':
        set = "sp";
        break;
      case 'cc':
        set = "cc";
        break;
      case 'cp':
        set = "cp";
        break;
      case 'spc':
        set = "spc";
        break;
    }
    return set;
  }


  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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


    bool _time;
    if (widget.i <= 15) {
      _time = true;
    } else {
      _time = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.dayData.year}年${widget.dayData.month}月${widget.dayData
                .day}日' +
                timeList[widget.i] + '~',style: TextStyle(fontFamily: 'GenJyuuGothic'),),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2),
          ),
          Text("コースを選択してください",style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 17),textAlign: TextAlign.center,),
          Padding(
            padding: EdgeInsets.all(2),
          ),
          RadioListTile(
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text('カットのみ',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'GenJyuuGothic',fontSize: 17),),
            subtitle: Text('値段:¥4,500(税抜き)  所要時間:1時間'),
            value: "cut",
            groupValue: _type,
            onChanged: _handleRadio,
          ),
          _time ?
          RadioListTile(
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text('カラーのみ',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'GenJyuuGothic',fontSize: 17),),
            subtitle: Text('値段:¥7,500(税抜き)  所要時間:1時間30分'),
            value: "color",
            groupValue: _type,
            onChanged: _handleRadio,
          ) : Container(),
          _time ?
          RadioListTile(
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text('パーマのみ',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'GenJyuuGothic',fontSize: 17),),
            subtitle: Text('値段:¥9,000(税抜き)  所要時間:2時間'),
            value: "perm",
            groupValue: _type,
            onChanged: _handleRadio,
          ) : Container(),
          _time ?
          RadioListTile(
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text('ストレートパーマのみ',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'GenJyuuGothic',fontSize: 17),),
            subtitle: Text('値段:¥15,000(税抜き)  所要時間:2時間30分'),
            value: "sp",
            groupValue: _type,
            onChanged: _handleRadio,
          ) : Container(),
          _time ?
          RadioListTile(
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text('カット ＋ カラー',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'GenJyuuGothic',fontSize: 17),),
            subtitle: Text('値段:¥10,500(税抜き)  所要時間:2時間'),
            value: "cc",
            groupValue: _type,
            onChanged: _handleRadio,
          ) : Container(),
          _time ?
          RadioListTile(
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text('カット ＋ パーマ',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'GenJyuuGothic',fontSize: 17),),
            subtitle: Text('値段:¥11,000(税抜き)  所要時間:2時間'),
            value: "cp",
            groupValue: _type,
            onChanged: _handleRadio,
          ) : Container(),
          _time ?
          RadioListTile(
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text('ストレートパーマ ＋ カラー',style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'GenJyuuGothic',fontSize: 17),),
            subtitle: Text('値段:¥20,000(税抜き)  所要時間:3時間30分'),
            value: "spc",
            groupValue: _type,
            onChanged: _handleRadio,
          ) : Container(),
          Divider(),




          RaisedButton(
              color: Colors.lightGreen,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text("予約",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'GenJyuuGothic'),),
              onPressed: () async {
                showAlertDialog(context);
                if (_change(_type) == "cut") {
                  Navigator.of(context, rootNavigator: true).pop();
                  return showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(10.0))),
                          title: Text("【予約確認】"),
                          content: Text("この内容で予約しますか？\n\n日付：${widget.dayData
                              .year}年${widget.dayData.month}月${widget.dayData
                              .day}日\n時間：${timeList[widget.i]}~${timeList[widget
                              .i + 2]}\nコース：カットのみ"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("キャンセル"),
                              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                            ),
                            FlatButton(
                                child: Text("予約する"),
                                onPressed: () async {
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
//                                      DocumentSnapshot docSnapshot = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i])
//                                          .get().catchError((err){
//                                        Navigator.of(context, rootNavigator: true).pop();
//                                        Navigator.of(context, rootNavigator: true).pop();
//                                        Navigator.of(context).pop();
//
//                                      });
//                                      DocumentSnapshot docSnapshot2 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 1])
//                                          .get();
//
//
//                                      Map<String, dynamic> record = docSnapshot
//                                          .data;
//                                      Map<String, dynamic> record2 = docSnapshot2
//                                          .data;

                                      if (_change(_type) == "cut") {
                                        return _handleSubmit(
                                            widget.dayData, timeList, widget.i,
                                            context);
                                      }
//                                      if ((_change(_type) == "cut") &&
//                                          (record != null ||
//                                              record2 != null)) {
//                                        return signOut();
//                                      }
                                    }
                                  } on SocketException catch (_) {
                                    print('not connected');
                                    Navigator.of(context, rootNavigator: true).pop();
                                    return Flushbar(
                                      message: "インターネットに接続されていません",
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }

                                }

                            ),
                          ],
                        );
                      }
                  );
                }





                if ((_change(_type) == "color")) {
                  Navigator.of(context, rootNavigator: true).pop();
                  return showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(10.0))),
                          title: Text("【予約確認】"),
                          content: Text("この内容で予約しますか？\n\n日付：${widget.dayData
                              .year}年${widget.dayData.month}月${widget.dayData
                              .day}日\n時間：${timeList[widget.i]}~${timeList[widget
                              .i + 3]}\nコース：カラーのみ"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("キャンセル"),
                              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                            ),
                            FlatButton(
                                child: Text("予約する"),
                                onPressed: () async {
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
//                                      DocumentSnapshot docSnapshot = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i])
//                                          .get();
//                                      DocumentSnapshot docSnapshot2 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 1])
//                                          .get();
//                                      DocumentSnapshot docSnapshot3 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 2])
//                                          .get();
//
//                                      Map<String, dynamic> record = docSnapshot
//                                          .data;
//                                      Map<String, dynamic> record2 = docSnapshot2
//                                          .data;
//                                      Map<String, dynamic> record3 = docSnapshot3
//                                          .data;
                                      if (_change(_type) == "color") {
                                        return _handleSubmit2(
                                            widget.dayData, timeList, widget.i,
                                            context);
                                      }
//                                      if (_change(_type) == "color" &&
//                                          (record != null ||
//                                              record2 != null ||
//                                              record3 != null)) {
//                                        return signOut();
//                                      }
                                    }
                                  } on SocketException catch (_) {
                                    print('not connected');
                                    Navigator.of(context, rootNavigator: true).pop();
                                    return Flushbar(
                                      message: "インターネットに接続されていません",
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }


                                }


                            ),
                          ],
                        );
                      }
                  );
                }



                if (_change(_type) == "perm") {
                  Navigator.of(context, rootNavigator: true).pop();
                  return showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(10.0))),
                          title: Text("【予約確認】"),
                          content: Text("この内容で予約しますか？\n\n日付：${widget.dayData
                              .year}年${widget.dayData.month}月${widget.dayData
                              .day}日\n時間：${timeList[widget.i]}~${timeList[widget
                              .i + 4]}\nコース：パーマのみ"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("キャンセル"),
                              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                            ),
                            FlatButton(
                                child: Text("予約する"),
                                onPressed: () async {
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
//                                      DocumentSnapshot docSnapshot = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i])
//                                          .get();
//                                      DocumentSnapshot docSnapshot2 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 1])
//                                          .get();
//                                      DocumentSnapshot docSnapshot3 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 2])
//                                          .get();
//                                      DocumentSnapshot docSnapshot4 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 3])
//                                          .get();
//
//                                      Map<String, dynamic> record = docSnapshot
//                                          .data;
//                                      Map<String, dynamic> record2 = docSnapshot2
//                                          .data;
//                                      Map<String, dynamic> record3 = docSnapshot3
//                                          .data;
//                                      Map<String, dynamic> record4 = docSnapshot4
//                                          .data;
                                      if (_change(_type) == "perm") {
                                        return _handleSubmit3(
                                            widget.dayData, timeList, widget.i,
                                            context);
                                      }
//                                      if (_change(_type) == "perm" &&
//                                          (record != null ||
//                                              record2 != null ||
//                                              record3 != null &&
//                                                  record4 != null)) {
//                                        return signOut();
//                                      }
                                    }
                                  } on SocketException catch (_) {
                                    print('not connected');
                                    Navigator.of(context, rootNavigator: true).pop();
                                    return Flushbar(
                                      message: "インターネットに接続されていません",
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }

                                }

                            ),
                          ],
                        );
                      }
                  );
                }


                if (_change(_type) == "sp") {
                  Navigator.of(context, rootNavigator: true).pop();
                  return showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(10.0))),
                          title: Text("【予約確認】"),
                          content: Text("この内容で予約しますか？\n\n日付：${widget.dayData
                              .year}年${widget.dayData.month}月${widget.dayData
                              .day}日\n時間：${timeList[widget.i]}~${timeList[widget
                              .i + 5]}\nコース：ストレートパーマのみ"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("キャンセル"),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                            ),
                            FlatButton(
                                child: Text("予約する"),
                                onPressed: () async {
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
//                                      DocumentSnapshot docSnapshot = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i])
//                                          .get();
//                                      DocumentSnapshot docSnapshot2 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 1])
//                                          .get();
//                                      DocumentSnapshot docSnapshot3 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 2])
//                                          .get();
//                                      DocumentSnapshot docSnapshot4 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 3])
//                                          .get();
//                                      DocumentSnapshot docSnapshot5 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 4])
//                                          .get();
//
//                                      Map<String, dynamic> record = docSnapshot
//                                          .data;
//                                      Map<String, dynamic> record2 = docSnapshot2
//                                          .data;
//                                      Map<String, dynamic> record3 = docSnapshot3
//                                          .data;
//                                      Map<String, dynamic> record4 = docSnapshot4
//                                          .data;
//                                      Map<String, dynamic> record5 = docSnapshot5
//                                          .data;
                                      if (_change(_type) == "sp") {
                                        return _handleSubmit4(
                                            widget.dayData, timeList, widget.i,
                                            context);
                                      }
//                                      if (_change(_type) == "sp" &&
//                                          (record != null ||
//                                              record2 != null ||
//                                              record3 != null &&
//                                                  record4 != null &&
//                                                  record5 != null)) {
//                                        return signOut();
//                                      }
                                    }
                                  } on SocketException catch (_) {
                                    print('not connected');
                                    Navigator.of(context, rootNavigator: true).pop();
                                    return Flushbar(
                                      message: "インターネットに接続されていません",
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }

                                }

                            ),
                          ],
                        );
                      }
                  );
                }
//                if(_change(_type) == "sp" && (record != null || record2 != null || record3 != null || record4 != null || record5 != null)){
//                  return signOut();
//                }

                if (_change(_type) == "cc") {
                  Navigator.of(context, rootNavigator: true).pop();
                  return showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(10.0))),
                          title: Text("【予約確認】"),
                          content: Text("この内容で予約しますか？\n\n日付：${widget.dayData
                              .year}年${widget.dayData.month}月${widget.dayData
                              .day}日\n時間：${timeList[widget.i]}~${timeList[widget
                              .i + 4]}\nコース：カット + カラー"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("キャンセル"),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                            ),
                            FlatButton(
                                child: Text("予約する"),
                                onPressed: () async {
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
//                                      DocumentSnapshot docSnapshot = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i])
//                                          .get();
//                                      DocumentSnapshot docSnapshot2 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 1])
//                                          .get();
//                                      DocumentSnapshot docSnapshot3 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 2])
//                                          .get();
//                                      DocumentSnapshot docSnapshot4 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 3])
//                                          .get();
//
//                                      Map<String, dynamic> record = docSnapshot
//                                          .data;
//                                      Map<String, dynamic> record2 = docSnapshot2
//                                          .data;
//                                      Map<String, dynamic> record3 = docSnapshot3
//                                          .data;
//                                      Map<String, dynamic> record4 = docSnapshot4
//                                          .data;
                                      if (_change(_type) == "cc") {
                                        return _handleSubmit5(
                                            widget.dayData, timeList, widget.i,
                                            context);
                                      }
//                                      if (_change(_type) == "cc" &&
//                                          (record != null ||
//                                              record2 != null ||
//                                              record3 != null &&
//                                                  record4 != null)) {
//                                        return signOut();
//                                      }
                                    }
                                  } on SocketException catch (_) {
                                    print('not connected');
                                    Navigator.of(context, rootNavigator: true).pop();
                                    return Flushbar(
                                      message: "インターネットに接続されていません",
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }

                                }

                            ),
                          ],
                        );
                      }
                  );
                }
//                if(_change(_type) == "cc" && (record != null || record2 != null || record3 != null || record4 != null)){
//                  return signOut();
//                }

                if (_change(_type) == "cp") {
                  Navigator.of(context, rootNavigator: true).pop();
                  return showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(10.0))),
                          title: Text("【予約確認】"),
                          content: Text("この内容で予約しますか？\n\n日付：${widget.dayData
                              .year}年${widget.dayData.month}月${widget.dayData
                              .day}日\n時間：${timeList[widget.i]}~${timeList[widget
                              .i + 4]}\nコース：カット + パーマ"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("キャンセル"),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                            ),
                            FlatButton(
                                child: Text("予約する"),
                                onPressed: () async {
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
//                                      DocumentSnapshot docSnapshot = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i])
//                                          .get();
//                                      DocumentSnapshot docSnapshot2 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 1])
//                                          .get();
//                                      DocumentSnapshot docSnapshot3 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 2])
//                                          .get();
//                                      DocumentSnapshot docSnapshot4 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 3])
//                                          .get();
//
//                                      Map<String, dynamic> record = docSnapshot
//                                          .data;
//                                      Map<String, dynamic> record2 = docSnapshot2
//                                          .data;
//                                      Map<String, dynamic> record3 = docSnapshot3
//                                          .data;
//                                      Map<String, dynamic> record4 = docSnapshot4
//                                          .data;
                                      if (_change(_type) == "cp") {
                                        return _handleSubmit6(
                                            widget.dayData, timeList, widget.i,
                                            context);
                                      }
//                                      if (_change(_type) == "cp" &&
//                                          (record != null ||
//                                              record2 != null ||
//                                              record3 != null &&
//                                                  record4 != null)) {
//                                        return signOut();
//                                      }
                                    }
                                  } on SocketException catch (_) {
                                    print('not connected');
                                    Navigator.of(context, rootNavigator: true).pop();
                                    return Flushbar(
                                      message: "インターネットに接続されていません",
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }

                                }

                            ),
                          ],
                        );
                      }
                  );
                }
//                if(_change(_type) == "cp" && (record != null || record2 != null || record3 != null || record4 != null)){
//                  return signOut();
//                }

                if (_change(_type) == "spc") {
                  Navigator.of(context, rootNavigator: true).pop();
                  return showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(10.0))),
                          title: Text("【予約確認】"),
                          content: Text("この内容で予約しますか？\n\n日付：${widget.dayData
                              .year}年${widget.dayData.month}月${widget.dayData
                              .day}日\n時間：${timeList[widget.i]}~${timeList[widget
                              .i + 7]}\nコース：ストレートパーマ + カラー"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("キャンセル"),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                            ),
                            FlatButton(
                                child: Text("予約する"),
                                onPressed: () async {
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
//                                      DocumentSnapshot docSnapshot = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i])
//                                          .get();
//                                      DocumentSnapshot docSnapshot2 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 1])
//                                          .get();
//                                      DocumentSnapshot docSnapshot3 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 2])
//                                          .get();
//                                      DocumentSnapshot docSnapshot4 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 3])
//                                          .get();
//                                      DocumentSnapshot docSnapshot5 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 4])
//                                          .get();
//                                      DocumentSnapshot docSnapshot6 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 5])
//                                          .get();
//                                      DocumentSnapshot docSnapshot7 = await Firestore
//                                          .instance.collection('schedule')
//                                          .doc("${widget.dayData.year}-${widget.dayData
//                                          .month}-${widget.dayData.day}")
//                                          .collection("time")
//                                          .doc(timeList[widget.i + 6])
//                                          .get();
//                                      Map<String, dynamic> record = docSnapshot
//                                          .data;
//                                      Map<String, dynamic> record2 = docSnapshot2
//                                          .data;
//                                      Map<String, dynamic> record3 = docSnapshot3
//                                          .data;
//                                      Map<String, dynamic> record4 = docSnapshot4
//                                          .data;
//                                      Map<String, dynamic> record5 = docSnapshot5
//                                          .data;
//                                      Map<String, dynamic> record6 = docSnapshot6
//                                          .data;
//                                      Map<String, dynamic> record7 = docSnapshot7
//                                          .data;
                                      if (_change(_type) == "spc") {
                                        return _handleSubmit7(
                                            widget.dayData, timeList, widget.i,
                                            context);
                                      }
//                                      if (_change(_type) == "spc" &&
//                                          (record != null ||
//                                              record3 != null ||
//                                              record5 != null ||
//                                              record7 != null)) {
//                                        return signOut();
//                                      }

                                    }
                                  } on SocketException catch (_) {
                                    print('not connected');
                                    Navigator.of(context, rootNavigator: true).pop();
                                    return Flushbar(
                                      message: "インターネットに接続されていません",
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }

                                }

                            ),
                          ],
                        );
                      }
                  );
                }
//                if(_change(_type) == "spc" && (record['time'] != null || record2['time'] != null || record3['time'] != null || record4['time'] != null || record5['time'] != null || record6['time'] != null || record7['time'] != null)){
//                  return signOut();
//                }
                if (_change(_type) != "cut" && _change(_type) != "color" &&
                    _change(_type) != "perm" && _change(_type) != "sp" &&
                    _change(_type) != "cc" && _change(_type) != "cp" &&
                    _change(_type) != "spc") {
                  return error();
                }

//                Navigator.of(context).pop();
              }
          ),
        ],
      ),
    );
  }

  String filePath;


  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/data.csv';

    return File('$path/data.csv').create();
  }







  getCsv() async {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;



  }




  void bookingNot() {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            title: Text("【予約できません】"),
            content: Text("その時間はすでに予約されています。\n所要時間分空きがあるかもう一度確認してください。"),
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

  void error() {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("コースを選択してください。"),
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

//  sendMailAndAttachment() async {
//    final Email uid = Email(
//      body:
//      'Hey, the CSV made it!',
//      subject: 'Datum Entry for ${DateTime.now().toString()}',
//      recipients: ['abc@123.xyz'],
////      attachmentPath: filePath,
//      isHTML: true,
//
//    );
//
//    await FlutterEmailSender.send(uid);
//  }


  _mail()async{
    final smtpServer = gmail('mail319tk@gmail.com', "********");
    final message = new Message()
      ..from = new Address('mail319tk@gmail.com', 'riku')
      ..recipients.add('land12riku@gmail.com')
      ..subject = '予約データ'
      ..text = '予約データのcsvファイル'
      ..html = ''
      ..attachments.add(FileAttachment(File(filePath)));
    var connection = PersistentConnection(smtpServer);
    await connection.send(message);
  }









  _handleSubmit(DateTime dayData, List<String> time, int i, context) async{


    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;
    var db = FirebaseFirestore.instance;
    var utc;

    if(time[i + 2] == '10:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 1, 00);
    }else if(time[i + 2] == '10:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 1, 30);
    } else if(time[i + 2] == '11:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 00);
    } else if(time[i + 2] == '11:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 30);
    }else if(time[i + 2] == '12:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 00);
    }else if(time[i + 2] == '12:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 30);
    }else if(time[i + 2] == '13:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 00);
    }else if(time[i + 2] == '13:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 30);
    }else if(time[i + 2] == '14:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 00);
    }else if(time[i + 2] == '14:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 30);
    }else if(time[i + 2] == '15:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 00);
    }else if(time[i + 2] == '15:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 30);
    }else if(time[i + 2] == '16:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 00);
    }else if(time[i + 2] == '16:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 30);
    }else if(time[i + 2] == '17:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 00);
    }else if(time[i + 2] == '17:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 30);
    }else if(time[i + 2] == '18:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 00);
    }else if(time[i + 2] == '18:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 30);
    }
    bool alert = false;




    db.runTransaction((Transaction tx) async{



      DocumentSnapshot productSnapshot = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]));
      DocumentSnapshot productSnapshot2 = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i + 1]));



      if(!productSnapshot.exists && !productSnapshot2.exists) {
          await tx.update(
              db.collection("user_information").doc(user.uid), {
            "type": "カットのみ",
            "schedule": time[i] + "~" + time[i + 2],
            "time": utc,
          });
          await tx.set(db.collection('schedule')
              .doc("${dayData.year}-${dayData.month}-${dayData.day}")
              .collection("time").doc(time[i]), {
            "uid": user.uid,
          });
          await tx.set(db.collection('schedule')
              .doc("${dayData.year}-${dayData.month}-${dayData.day}")
              .collection("time").doc(time[i + 1]), {
            "uid": user.uid,
          });


      }else{
        bookingNot();
        alert =  true;
      }




    }).then((value) async{
      DocumentSnapshot productSnapshot = await db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]).get();


      if(productSnapshot.exists && productSnapshot.data()['uid'] == user.uid){
        List<List<dynamic>> rows = List<List<dynamic>>();

        var cloud = await FirebaseFirestore.instance
            .collection("user_information")
            .doc(user.uid)
            .get();

        rows.add([
          "姓",
          "名",
          "携帯電話番号",
          "コース",
          "日付",
          "時間",
        ]);

        if (cloud.data != null) {
          List<dynamic> row = List<dynamic>();
          row.add(cloud.data()["lastName"]);
          row.add(cloud.data()["firstName"]);
          row.add(cloud.data()["tel"]);
          row.add("カットのみ");
          row.add('${utc.year}年${utc.month}月${utc.day}日');
          row.add('${time[i]}~${time[i + 2]}');
          rows.add(row);
        }

        File f = await _localFile;
        String csv = const ListToCsvConverter().convert(rows);
        await f.writeAsString(csv);


        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
        _mail();
        Flushbar(
          message: "予約が完了しました",
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        )
          ..show(context);
      }
      if(alert == false && !productSnapshot.exists && productSnapshot.data()['uid'] != user.uid){
        bookingNot();
      }
    });




  }

  _handleSubmit2(DateTime dayData, List<String> time, int i, context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;
    var db = FirebaseFirestore.instance;
    var utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 30);

    if(time[i + 3] == '10:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 1, 30);
    }else if(time[i + 3] == '11:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 00);
    } else if(time[i + 3] == '11:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 30);
    }else if(time[i + 3] == '12:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 00);
    }else if(time[i + 3] == '12:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 30);
    }else if(time[i + 3] == '13:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 00);
    }else if(time[i + 3] == '13:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 30);
    }else if(time[i + 3] == '14:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 00);
    }else if(time[i + 3] == '14:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 30);
    }else if(time[i + 3] == '15:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 00);
    }else if(time[i + 3] == '15:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 30);
    }else if(time[i + 3] == '16:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 00);
    }else if(time[i + 3] == '16:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 30);
    }else if(time[i + 3] == '17:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 00);
    }else if(time[i + 3] == '17:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 30);
    }else if(time[i + 3] == '18:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 00);
    }
    bool alert = false;

    db.runTransaction((Transaction tx) async{

      DocumentSnapshot productSnapshot = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]));
      DocumentSnapshot productSnapshot2 = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i + 1]));
      DocumentSnapshot productSnapshot3 = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i + 2]));



      if(!productSnapshot.exists && !productSnapshot2.exists && !productSnapshot3.exists) {
        await tx.update(db.collection("user_information").doc(user.uid), {
          "type": "カラーのみ",
          "schedule": time[i] + "~" + time[i + 3],
          "time": utc,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]), {
          "uid": user.uid,
        });

      }else{
        bookingNot();
        alert = true;
      }


    }).then((v) async{
      DocumentSnapshot productSnapshot = await db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i + 1]).get();

      if(productSnapshot.exists && productSnapshot.data()['uid'] == user.uid) {
        List<List<dynamic>> rows = List<List<dynamic>>();

        var cloud = await FirebaseFirestore.instance
            .collection("user_information")
            .doc(user.uid)
            .get();

        rows.add([
          "姓",
          "名",
          "携帯電話番号",
          "コース",
          "日付",
          "時間",
        ]);

        if (cloud.data != null) {
          List<dynamic> row = List<dynamic>();
          row.add(cloud.data()["lastName"]);
          row.add(cloud.data()["firstName"]);
          row.add(cloud.data()["tel"]);
          row.add(cloud.data()["type"]);
          row.add('${utc.year}年${utc.month}月${utc.day}日');
          row.add('${time[i]}~${time[i + 3]}');
          rows.add(row);




        }

        File f = await _localFile;
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);




        _mail();

        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
        Flushbar(
          message: "予約が完了しました",
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        )..show(context);
      }
      if(alert == false && !productSnapshot.exists && productSnapshot.data()['uid'] != user.uid){
        bookingNot();
      }
    });


  }

  _handleSubmit3(DateTime dayData, List<String> time, int i, context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;
    var db = FirebaseFirestore.instance;
    var utc;

    if(time[i + 4] == '11:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 00);
    }else if(time[i + 4] == '11:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 30);
    }else if(time[i + 4] == '12:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 00);
    }else if(time[i + 4] == '12:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 30);
    }else if(time[i + 4] == '13:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 00);
    }else if(time[i + 4] == '13:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 30);
    }else if(time[i + 4] == '14:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 00);
    }else if(time[i + 4] == '14:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 30);
    }else if(time[i + 4] == '15:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 00);
    }else if(time[i + 4] == '15:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 30);
    }else if(time[i + 4] == '16:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 00);
    }else if(time[i + 4] == '16:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 30);
    }else if(time[i + 4] == '17:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 00);
    }else if(time[i + 4] == '17:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 30);
    }else if(time[i + 4] == '18:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 00);
    }else if(time[i + 4] == '18:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 30);
    }
    bool alert = false;

    db.runTransaction((Transaction tx) async{

      DocumentSnapshot productSnapshot = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]));
      DocumentSnapshot productSnapshot2 = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i + 1]));
      DocumentSnapshot productSnapshot3 = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i + 2]));
      DocumentSnapshot productSnapshot4 = await tx.get(db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i + 3]));



      if(!productSnapshot.exists && !productSnapshot2.exists && !productSnapshot3.exists && !productSnapshot4.exists) {
        await tx.update(db.collection("user_information").doc(user.uid), {
          "type": "パーマのみ",
          "schedule": time[i] + "~" + time[i + 4],
          "time": utc,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]), {
          "uid": user.uid,
        });


      }else{
        bookingNot();
        alert = true;
      }




    }).then((value) async{
      DocumentSnapshot productSnapshot = await db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]).get();


      if(productSnapshot.exists && productSnapshot.data()['uid'] == user.uid){
        List<List<dynamic>> rows = List<List<dynamic>>();

        var cloud = await FirebaseFirestore.instance
            .collection("user_information")
            .doc(user.uid)
            .get();

        rows.add([
          "姓",
          "名",
          "携帯電話番号",
          "コース",
          "日付",
          "時間",
        ]);

        if (cloud.data != null) {
          List<dynamic> row = List<dynamic>();
          row.add(cloud.data()["lastName"]);
          row.add(cloud.data()["firstName"]);
          row.add(cloud.data()["tel"]);
          row.add("パーマのみ");
          row.add('${utc.year}年${utc.month}月${utc.day}日');
          row.add('${time[i]}~${time[i + 4]}');
          rows.add(row);




        }

        File f = await _localFile;
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);




        _mail();


        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
        Flushbar(
          message: "予約が完了しました",
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        )..show(context);
      }
      if(alert == false && !productSnapshot.exists && productSnapshot.data()['uid'] != user.uid){
        bookingNot();
      }


    });



  }

  _handleSubmit4(DateTime dayData, List<String> time, int i, context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;
    var db = FirebaseFirestore.instance;
    var utc;

    if(time[i + 5] == '11:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 30);
    }else if(time[i + 5] == '12:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 00);
    }else if(time[i + 5] == '12:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 30);
    }else if(time[i + 5] == '13:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 00);
    }else if(time[i + 5] == '13:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 30);
    }else if(time[i + 5] == '14:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 00);
    }else if(time[i + 5] == '14:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 30);
    }else if(time[i + 5] == '15:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 00);
    }else if(time[i + 5] == '15:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 30);
    }else if(time[i + 5] == '16:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 00);
    }else if(time[i + 5] == '16:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 30);
    }else if(time[i + 5] == '17:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 00);
    }else if(time[i + 5] == '17:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 30);
    }else if(time[i + 5] == '18:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 00);
    }else if(time[i + 5] == '18:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 30);
    } else if(time[i + 5] == '19:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 10, 00);
    }
    bool alert = false;

    db.runTransaction((Transaction tx) async{

      DocumentSnapshot productSnapshot = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]));
      DocumentSnapshot productSnapshot2 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]));
      DocumentSnapshot productSnapshot3 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]));
      DocumentSnapshot productSnapshot4 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]));
      DocumentSnapshot productSnapshot5 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 4]));



      if(!productSnapshot.exists && !productSnapshot2.exists && !productSnapshot3.exists && !productSnapshot4.exists && !productSnapshot5.exists) {
        await tx.update(db.collection("user_information").doc(user.uid), {
          "type": "ストレートパーマのみ",
          "schedule": time[i] + "~" + time[i + 5],
          "time": utc,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 4]), {
          "uid": user.uid,
        });



      }else{
        bookingNot();
        alert = true;
      }




    }).then((value) async{
      DocumentSnapshot productSnapshot = await db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]).get();


      if(productSnapshot.exists && productSnapshot.data()['uid'] == user.uid){
        List<List<dynamic>> rows = List<List<dynamic>>();

        var cloud = await FirebaseFirestore.instance
            .collection("user_information")
            .doc(user.uid)
            .get();

        rows.add([
          "姓",
          "名",
          "携帯電話番号",
          "コース",
          "日付",
          "時間",
        ]);

        if (cloud.data != null) {
          List<dynamic> row = List<dynamic>();
          row.add(cloud.data()["lastName"]);
          row.add(cloud.data()["firstName"]);
          row.add(cloud.data()["tel"]);
          row.add("ストレートパーマのみ");
          row.add('${utc.year}年${utc.month}月${utc.day}日');
          row.add('${time[i]}~${time[i + 5]}');
          rows.add(row);




        }

        File f = await _localFile;
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);




        _mail();


        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
        Flushbar(
          message: "予約が完了しました",
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        )..show(context);
      }
      if(alert == false && !productSnapshot.exists && productSnapshot.data()['uid'] != user.uid){
        bookingNot();
      }

    });



  }

  _handleSubmit5(DateTime dayData, List<String> time, int i, context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;
    var db = FirebaseFirestore.instance;
    var utc;

    if(time[i + 4] == '11:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 00);
    }else if(time[i + 4] == '11:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 30);
    }else if(time[i + 4] == '12:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 00);
    }else if(time[i + 4] == '12:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 30);
    }else if(time[i + 4] == '13:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 00);
    }else if(time[i + 4] == '13:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 30);
    }else if(time[i + 4] == '14:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 00);
    }else if(time[i + 4] == '14:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 30);
    }else if(time[i + 4] == '15:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 00);
    }else if(time[i + 4] == '15:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 30);
    }else if(time[i + 4] == '16:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 00);
    }else if(time[i + 4] == '16:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 30);
    }else if(time[i + 4] == '17:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 00);
    }else if(time[i + 4] == '17:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 30);
    }else if(time[i + 4] == '18:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 00);
    }else if(time[i + 4] == '18:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 30);
    }
    bool alert = false;

    db.runTransaction((Transaction tx) async{

      DocumentSnapshot productSnapshot = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]));
      DocumentSnapshot productSnapshot2 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]));
      DocumentSnapshot productSnapshot3 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]));
      DocumentSnapshot productSnapshot4 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]));



      if(!productSnapshot.exists && !productSnapshot2.exists && !productSnapshot3.exists && !productSnapshot4.exists) {
        await tx.update(db.collection("user_information").doc(user.uid), {
          "type": "カット + カラー",
          "schedule": time[i] + "~" + time[i + 4],
          "time": utc,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]), {
          "uid": user.uid,
        });



      }else{
        bookingNot();
        alert = true;
      }

    }).then((value) async{
      DocumentSnapshot productSnapshot = await db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]).get();


      if(productSnapshot.exists && productSnapshot.data()['uid'] == user.uid){
        List<List<dynamic>> rows = List<List<dynamic>>();

        var cloud = await FirebaseFirestore.instance
            .collection("user_information")
            .doc(user.uid)
            .get();

        rows.add([
          "姓",
          "名",
          "携帯電話番号",
          "コース",
          "日付",
          "時間",
        ]);

        if (cloud.data != null) {
          List<dynamic> row = List<dynamic>();
          row.add(cloud.data()["lastName"]);
          row.add(cloud.data()["firstName"]);
          row.add(cloud.data()["tel"]);
          row.add("カット + カラー");
          row.add('${utc.year}年${utc.month}月${utc.day}日');
          row.add('${time[i]}~${time[i + 4]}');
          rows.add(row);




        }

        File f = await _localFile;
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);




        _mail();



        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
        Flushbar(
          message: "予約が完了しました",
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        )..show(context);
      }
      if(alert == false && !productSnapshot.exists && productSnapshot.data()['uid'] != user.uid){
        bookingNot();
      }


    });



  }

  _handleSubmit6(DateTime dayData, List<String> time, int i, context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;
    var db = FirebaseFirestore.instance;
    var utc;

    if(time[i + 4] == '11:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 00);
    }else if(time[i + 4] == '11:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 2, 30);
    }else if(time[i + 4] == '12:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 00);
    }else if(time[i + 4] == '12:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 30);
    }else if(time[i + 4] == '13:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 00);
    }else if(time[i + 4] == '13:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 30);
    }else if(time[i + 4] == '14:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 00);
    }else if(time[i + 4] == '14:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 30);
    }else if(time[i + 4] == '15:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 00);
    }else if(time[i + 4] == '15:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 30);
    }else if(time[i + 4] == '16:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 00);
    }else if(time[i + 4] == '16:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 30);
    }else if(time[i + 4] == '17:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 00);
    }else if(time[i + 4] == '17:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 30);
    }else if(time[i + 4] == '18:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 00);
    }else if(time[i + 4] == '18:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 30);
    }
    bool alert = false;


    db.runTransaction((Transaction tx) async{

      DocumentSnapshot productSnapshot = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]));
      DocumentSnapshot productSnapshot2 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]));
      DocumentSnapshot productSnapshot3 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]));
      DocumentSnapshot productSnapshot4 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]));



      if(!productSnapshot.exists && !productSnapshot2.exists && !productSnapshot3.exists && !productSnapshot4.exists) {
        await tx.update(db.collection("user_information").doc(user.uid), {
          "type": "カット + パーマ",
          "schedule": time[i] + "~" + time[i + 4],
          "time": utc,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]), {

          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]), {

          "uid": user.uid,
        });



      }else{
        bookingNot();
        alert = true;
      }


    }).then((value) async{
      DocumentSnapshot productSnapshot = await db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]).get();


      if(productSnapshot.exists && productSnapshot.data()['uid'] == user.uid){
        List<List<dynamic>> rows = List<List<dynamic>>();

        var cloud = await FirebaseFirestore.instance
            .collection("user_information")
            .doc(user.uid)
            .get();

        rows.add([
          "姓",
          "名",
          "携帯電話番号",
          "コース",
          "日付",
          "時間",
        ]);

        if (cloud.data != null) {
          List<dynamic> row = List<dynamic>();
          row.add(cloud.data()["lastName"]);
          row.add(cloud.data()["firstName"]);
          row.add(cloud.data()["tel"]);
          row.add("カット + パーマ");
          row.add('${utc.year}年${utc.month}月${utc.day}日');
          row.add('${time[i]}~${time[i + 4]}');
          rows.add(row);




        }

        File f = await _localFile;
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);




        _mail();


        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
        Flushbar(
          message: "予約が完了しました",
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        )..show(context);
      }
      if(alert == false && !productSnapshot.exists && productSnapshot.data()['uid'] != user.uid){
        bookingNot();
      }

    });



  }

  _handleSubmit7(DateTime dayData, List<String> time, int i, context) {
    final UserState userState = Provider.of<UserState>(context, listen: false);
    final auth.User user = userState.user;
    var db = FirebaseFirestore.instance;
    var utc;
    if(time[i + 7] == '12:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 3, 30);
    }else if(time[i + 7] == '13:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 00);
    }else if(time[i + 7] == '13:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 4, 30);
    }else if(time[i + 7] == '14:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 00);
    }else if(time[i + 7] == '14:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 5, 30);
    }else if(time[i + 7] == '15:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 00);
    }else if(time[i + 7] == '15:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 6, 30);
    }else if(time[i + 7] == '16:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 00);
    }else if(time[i + 7] == '16:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 7, 30);
    }else if(time[i + 7] == '17:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 00);
    }else if(time[i + 7] == '17:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 8, 30);
    }else if(time[i + 7] == '18:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 00);
    }else if(time[i + 7] == '18:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 9, 30);
    }else if(time[i + 7] == '19:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 10, 00);
    }else if(time[i + 7] == '19:30'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 10, 30);
    }else if(time[i + 7] == '20:00'){
      utc = DateTime.utc(dayData.year, dayData.month, dayData.day, 11, 00);
    }
    bool alert = false;


    db.runTransaction((Transaction tx) async{

      DocumentSnapshot productSnapshot = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]));
      DocumentSnapshot productSnapshot2 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]));
      DocumentSnapshot productSnapshot3 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]));
      DocumentSnapshot productSnapshot4 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]));
      DocumentSnapshot productSnapshot5 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 4]));
      DocumentSnapshot productSnapshot6 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 5]));
      DocumentSnapshot productSnapshot7 = await tx.get(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 6]));



      if(!productSnapshot.exists && !productSnapshot2.exists && !productSnapshot3.exists && !productSnapshot4.exists && !productSnapshot5.exists && !productSnapshot6.exists && !productSnapshot7.exists) {
        await tx.update(db.collection("user_information").doc(user.uid), {
          "type": "ストレートパーマ + カラー",
          "schedule": time[i] + "~" + time[i + 7],
          "time": utc,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 1]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 2]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 3]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 4]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 5]), {
          "uid": user.uid,
        });
        await tx.set(db.collection('schedule')
            .doc("${dayData.year}-${dayData.month}-${dayData.day}")
            .collection("time").doc(time[i + 6]), {
          "uid": user.uid,
        });


      }else{
        bookingNot();
        alert = true;
      }





    }).then((value) async{
      DocumentSnapshot productSnapshot = await db.collection('schedule')
          .doc("${dayData.year}-${dayData.month}-${dayData.day}")
          .collection("time").doc(time[i]).get();


      if(productSnapshot.exists && productSnapshot.data()['uid'] == user.uid){
        List<List<dynamic>> rows = List<List<dynamic>>();

        var cloud = await FirebaseFirestore.instance
            .collection("user_information")
            .doc(user.uid)
            .get();

        rows.add([
          "姓",
          "名",
          "携帯電話番号",
          "コース",
          "日付",
          "時間",
        ]);

        if (cloud.data != null) {
          List<dynamic> row = List<dynamic>();
          row.add(cloud.data()["lastName"]);
          row.add(cloud.data()["firstName"]);
          row.add(cloud.data()["tel"]);
          row.add("ストレートパーマ + カラー");
          row.add('${utc.year}年${utc.month}月${utc.day}日');
          row.add('${time[i]}~${time[i + 7]}');
          rows.add(row);




        }

        File f = await _localFile;
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);




        _mail();


        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
        Flushbar(
          message: "予約が完了しました",
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        )..show(context);
      }
      if(alert == false && !productSnapshot.exists && productSnapshot.data()['uid'] != user.uid){
        bookingNot();
      }



    }).catchError((err) {
      print(err);
    });



  }

}
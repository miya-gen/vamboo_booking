import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'booking_confirm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


class TimeSchedule extends StatefulWidget {
  final DateTime dayData;
  const TimeSchedule({@required this.dayData, Key key}) : super(key: key);


  @override
  _TimeScheduleState createState() => _TimeScheduleState();
}

class _TimeScheduleState extends State<TimeSchedule> with AutomaticKeepAliveClientMixin {

  List<String> timeList = [' 9:00', ' 9:30','10:00','10:30','11:00','11:30','12:00','12:30','13:00','13:30','14:00','14:30','15:00','15:30','16:00','16:30','17:00','17:30','18:00','18:30','19:00','19:30','20:00','20:30','21:00','21:00'];

  get wantKeepAlive => true;
  bool isLoading = false;


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

    super.build(context);
    final UserState userState = Provider.of<UserState>(context);
    final auth.User user = userState.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.dayData.year}年${widget.dayData.month}月${widget.dayData
                .day}日',style: TextStyle(fontFamily: 'GenJyuuGothic'),),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("schedule")
                    .doc("${widget.dayData.year}-${widget.dayData.month}-${widget.dayData.day}")
                    .collection("time")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView.builder(
                      itemBuilder: (_, int i){
                        int index;
                        bool time = false;
                        bool book = false;
                        bool attention = false;
                        for(index=0; index < snapshot.data.docs.length; index++){
                          if(snapshot.data.docs[index].id == timeList[i]){
                            time = true;
                            if(snapshot.data != null && snapshot.data.docs[index].data()['uid'] == user.uid){
                              book = true;
                            }
                          }
                        }
                        if(i >= 1){
                          attention = true;
                        }
                        bool edit = false;

                        if ("${snapshot.data}" == timeList[i]){
                          time = true;
                          if(snapshot.data != null && snapshot.data == user.uid){
                            book = true;
                          }
                        }
                        if(user.email == 'land12riku@gmail.com'){
                          edit = true;
                        }

                        return edit ?
                        Column(
                          children: <Widget>[
                            if(attention == false)
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('予約が埋まっている場合でも電話予約なら予約できる場合があります。', style: TextStyle(color: Colors.red),),
                              ),
                            if(attention == false)
                              Divider(),
                            time ?
                            ListTile(
                              leading: Text(timeList[i] + '~'),
                              title: RaisedButton(
                                color: Colors.red,
                                textColor: Colors.white,
                                shape: StadiumBorder(),
                                child: Text('予約を取り消す',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'GenJyuuGothic'),),
                                onPressed: ()async{
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
                                      Navigator.of(context, rootNavigator: true).pop();
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(10.0))),
                                              content: Text("本当に予約を取り消しますか？"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("キャンセル"),
                                                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                                ),
                                                FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () async{
                                                    showAlertDialog(context);
                                                    var db = FirebaseFirestore.instance;
                                                    DocumentSnapshot docSnapshot = await db.collection('schedule')
                                                        .doc("${widget.dayData.year}-${widget.dayData.month}-${widget.dayData.day}")
                                                        .collection("time").doc(timeList[i])
                                                        .get();
                                                    Map<String, dynamic> record = docSnapshot
                                                        .data();
                                                    if(record['uid'] != null){
                                                      db.collection("user_information").doc(record['uid']).update({
                                                        "schedule": null,
                                                        "time": null,
                                                        "type": null,
                                                      });
                                                    }
                                                    db.collection('schedule')
                                                        .doc("${widget.dayData.year}-${widget.dayData.month}-${widget.dayData.day}")
                                                        .collection("time").doc(timeList[i]).delete();
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                      );
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
                            )
                                : ListTile(
                              leading: Text(timeList[i] + '~'),
                              title: RaisedButton(
                                color: Colors.lightGreen,
                                textColor: Colors.white,
                                shape: StadiumBorder(),
                                child: Text('予約状態にする',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'GenJyuuGothic'),),
                                onPressed: ()async{
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
                                      Navigator.of(context, rootNavigator: true).pop();
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(10.0))),
                                              content: Text("この時間の予約を埋めますか？"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("キャンセル"),
                                                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                                ),
                                                FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    var db = FirebaseFirestore.instance;
                                                    db.collection('schedule')
                                                        .doc("${widget.dayData.year}-${widget.dayData.month}-${widget.dayData.day}")
                                                        .collection("time").doc(timeList[i]).set({
                                                    },SetOptions(merge: true));
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                      );
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
                            ),
                            Divider()
                          ],
                        ): Column(
                          children: <Widget>[
                            if(attention == false)
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('予約が埋まっている場合でも電話予約なら予約できる場合があります。', style: TextStyle(color: Colors.red),),
                              ),
                            if(attention == false)
                              Divider(),
                            time ?
                            ListTile(
                              leading: Text(timeList[i] + '~'),
                              title: book ? Text('あなたの予約',textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue, fontFamily: 'GenJyuuGothic'),):Text("✖️",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 33, color: Colors.red, fontFamily: 'GenJyuuGothic'),),
                            )
                                : ListTile(
                              leading: Text(timeList[i] + '~'),
                              title: RaisedButton(
                                color: Colors.lightGreen,
                                textColor: Colors.white,
                                shape: StadiumBorder(),
                                child: Text('予約する',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'GenJyuuGothic'),),
                                onPressed: ()async{
                                  showAlertDialog(context);
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      print('connected');
                                      DocumentSnapshot docSnapshot = await FirebaseFirestore
                                          .instance.collection('user_information')
                                          .doc(user.uid)
                                          .get();
                                      Map<String, dynamic> record = docSnapshot.data();
                                      if(record["time"] != null && record["time"].toDate().compareTo(DateTime.now()) == 1){
                                        Navigator.of(context, rootNavigator: true).pop();
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                title: Text('【あなたは既に予約しています】',style: TextStyle(fontSize: 16),),
                                                content: Text("予約をキャンセルしたい場合は、当店までご連絡ください。"),
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

                                      }else{
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) =>
                                            Confirm(dayData: widget.dayData, i: i)));
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
                              ),
                            ),
                            Divider()
                          ],
                        );
                      },
                    itemCount: timeList.length - 8,
                  );

                }
            )


      ),
    );
  }
}







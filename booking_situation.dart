import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class BookingSituation extends StatefulWidget {
  @override
  _BookingSituationState createState() => _BookingSituationState();
}

class _BookingSituationState extends State<BookingSituation> {
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final auth.User user = userState.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('予約状況確認画面', style: TextStyle(fontFamily: 'GenJyuuGothic')),
      ),
      body: Container(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user_information")
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            bool schedule = false;
            bool bookingdata = false;
            if(snapshot.data.data()["schedule"] != null){
              schedule = true;
            }
            if(snapshot.data.data()["time"] != null && snapshot.data.data()["time"].toDate().compareTo(DateTime.now()) == -1){
              bookingdata = true;
            }
            return bookingdata ?
            Container(
              padding: EdgeInsets.all(14),
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Text('${snapshot.data.data()["lastName"]} ${snapshot.data.data()["firstName"]}さんの予約状況',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                  ),
                  Divider(),
                  ListTile(
                    leading: Text("コース"),
                    title: Text('予約はありません',textAlign: TextAlign.center,),
                  ),
                  Divider(),
                  ListTile(
                    leading: Text("予約日"),
                    title: Text('予約はありません',textAlign: TextAlign.center,),
                  ),
                  Divider(),
                  ListTile(
                    leading: Text("予約時刻"),
                    title: Text('予約はありません',textAlign: TextAlign.center,),
                  ),
                  Divider(),
                  Center(
                    child: Text('予約をキャンセルしたい場合は、（tel: 078-925-4155）までご連絡ください。',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,color: Colors.red),),
                  ),

                ],
              ),
            ):
              Container(
                padding: EdgeInsets.all(14),
                child: ListView(
                 children: <Widget>[
                   Center(
                     child: Text('${snapshot.data.data()["lastName"]} ${snapshot.data.data()["firstName"]}さんの予約状況',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                   ),
                   Divider(),
                   schedule ?
                   ListTile(
                     leading: Text("コース"),
                     title: Text(snapshot.data.data()["type"],textAlign: TextAlign.center,),
                   )
                   :ListTile(
                     leading: Text("コース"),
                     title: Text('予約はありません',textAlign: TextAlign.center,),
                   ),
                   Divider(),
                   schedule ?
                   ListTile(
                     leading: Text("予約日"),
                     title: Text("${snapshot.data.data()["time"].toDate().year}" + "年" + "${snapshot.data.data()["time"].toDate().month}" + "月" + "${snapshot.data.data()["time"].toDate().day}" + "日",textAlign: TextAlign.center,),
                   )
                       :ListTile(
                     leading: Text("予約日"),
                     title: Text('予約はありません',textAlign: TextAlign.center,),
                   ),
                   Divider(),
                   schedule ?
                   ListTile(
                     leading: Text("予約時刻"),
                     title: Text(snapshot.data.data()["schedule"],textAlign: TextAlign.center,),
                   )
                       :ListTile(
                     leading: Text("予約時刻"),
                     title: Text('予約はありません',textAlign: TextAlign.center,),
                   ),
                   Divider(),
                   Center(
                     child: Text('予約をキャンセルしたい場合は、\n（tel: 078-925-4155）までご連絡ください。',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,color: Colors.red),),
                   ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

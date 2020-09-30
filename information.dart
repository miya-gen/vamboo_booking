import 'package:flutter/material.dart';


class InformationInformation extends StatefulWidget {

  @override
  _InformationInformationState createState() => _InformationInformationState();
}

class _InformationInformationState extends State<InformationInformation> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('店舗情報', style: TextStyle(fontFamily: 'GenJyuuGothic')),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: ListView(
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset('images/store_image.jpg'),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            ListTile(
              leading: Text("サロン名",textAlign: TextAlign.center,),
              title: Text('vamboo【バンブー】',textAlign: TextAlign.center,),
            ),
            Divider(),
             ListTile(
              leading: Text("住所",textAlign: TextAlign.center,),
              title: Text('〒673-0005\n兵庫県明石市小久保5丁目12-2'),
            ),
            Divider(),


            ListTile(
              leading: Text("TEL",textAlign: TextAlign.center,),
              title: Text('078-925-4155',textAlign: TextAlign.center,),
            ),
            Divider(),
            ListTile(
              leading: Text("受付時間",textAlign: TextAlign.center,),
              title: Text('9:00 ~ 17:30',textAlign: TextAlign.center,),
            ),
            Divider(),
            ListTile(
              leading: Text("定休日",textAlign: TextAlign.center,),
              title: Text('月曜日、第２・３火曜日',textAlign: TextAlign.center,),
            ),
            Divider(),
            ListTile(
              leading: Text("駐車場",textAlign: TextAlign.center,),
              title: Text('５台（店前２台、横に３台） ',textAlign: TextAlign.center,),
            ),
            Divider(),
            ListTile(
              leading: Text("こだわり\n条件",textAlign: TextAlign.center,),
              title: Text('駐車場あり／ヘアセット／着付け／ドリンクサービスあり／カード支払いOK(VISA, Mastercardのみ)／禁煙 ',textAlign: TextAlign.center,),
            ),
            Divider(),
            ListTile(
              leading: Text("アクセス"),
              title: Text('JR西明石駅西口を出、左(西)へ道なりに歩き高架をくぐると右へカーブしています。そのカーブを過ぎると信号が見えます。その信号を渡り右に100均(フレッツ)を過ぎ、次の信号まで徒歩３～４分です。その信号(左に中谷塾、右にメイプル耳鼻科)をまっすぐ歩くと右にマツモトキヨシが見え、少し先の左手に白の看板(ピンクの柄)が当店となります。 '),
            ),

          ],
        ),
      )
    );
  }
}
//Row(
//children: <Widget>[
//Text('住所'),
//Text('           〒673-0005'),
//],
//),
//Padding(
//padding: EdgeInsets.only(left: 70),
//child: Row(
//children: <Widget>[
//Text('兵庫県明石市小久保5丁目12-2'),
//],
//),
//),
//Padding(
//padding: EdgeInsets.all(10),
//),
//Row(
//children: <Widget>[
//Text('TEL'),
//Text('            078-925-4155'),
//],
//),
//Padding(
//padding: EdgeInsets.all(10),
//),
//Row(
//children: <Widget>[
//Text('営業時間'),
//Text('     9:00 ~ 17:30'),
//],
//),
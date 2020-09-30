import 'package:flutter/material.dart';


class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プライバシーポリシー'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: ListView(
            children: <Widget>[
              Center(
                child: Text("【vamboo】プライバシーポリシー", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              Text("\nバンブー(vamboo)（以下「当店」という）は、当店の提供する【vamboo】の利用者（以下「ユーザー」という）に関する個人情報を含んだ情報（以下「ユーザー情報」という）の取扱いについて、以下のとおりプライバシーポリシー（以下「本ポリシー」という）を定めます。"),
              Text("\n１．情報を取得するアプリ提供者\nバンブー(vamboo)\n"),
              Text("２．取得するユーザー情報と目的\n本アプリケーションで取得するユーザー情報と目的は以下のとおりです。\n"),
              Text("取得するユーザー情報", style: TextStyle(fontWeight: FontWeight.bold),),
              Text("・デバイスの種類、モデル、メーカー\n・OS・キャリア情報\n・IPアドレス\n・IDFA、AAID、GAID\n・電話番号\n・氏名\n・メールアドレス\n"),
              Text("利用目的", style: TextStyle(fontWeight: FontWeight.bold),),
              Text("・パフォーマンス分析\n・アプリケーションの改善\n・ユーザーへのサポート\n"),
              Text("３．取得方法\n当店は、情報収集モジュールを内蔵した本アプリケーションにより、ユーザー情報を自動取得、またはユーザーの入力により取得します。\n"),
              Text("４．通知・公表または同意取得の方法・利用者関与の方法\n（１）通知・公表\n当店は、本ポリシーおよびバンブー(vamboo)プライバシーポリシーに関する通知・公表は本アプリケーションまたは当店のホームページに掲載する方法で行います。\n"),
              Text("（２）同意取得の方法\n同意の取得は、本アプリケーションのユーザー登録時に取得する方法で行います。\n"),
              Text("（３）利用者関与の方法\nユーザー情報の取得は、本アプリケーションをアンインストールすることで中止することができます。\n"),
              Text("５．外部送信・第三者提供・情報収集モジュール\n（１）外部送信\n取得したユーザー情報については、当店が管理を委託するホスティング会社のサーバーに送信されます。\n\n（２）第三者提供\n当店は、取得したユーザー情報について、以下の場合第三者に提供することがあります。\n・統計的なデータなどユーザーを識別することができない状態で提供する場合\n・法令に基づき開示・提供を求められた場合\n\n（３）情報収集モジュール\n当店は、本アプリケーションに以下の情報収集モジュールを組み込みます。\n"),
              Text("Firebase Analytics\n", style: TextStyle(color: Colors.red),),
              Text("６．お問い合わせ\n当店のプライバシーポリシーに関する、ご意見、ご質問、苦情の申出その他ユーザー情報の取扱いに関するお問い合わせは、以下の窓口にご連絡ください。\n"),
              Text("TeL: 078-925-4155\n", style: TextStyle(color: Colors.red),),
              Text("７．改定\n当店は、当店の裁量に基づいて、本ポリシーを変更します。但し、取得するユーザー情報、利用目的、第三者提供に変更が発生した場合、本アプリケーションまたは当店のホームページで通知します。\n"),
              Text("８．バンブー(vamboo)プライバシーポリシー\n本ポリシーに定めのない事項については、バンブー(vamboo)プライバシーポリシーが適用されます。\n"),
              Text("９．制定日・改定日\n制定：2020年8月14日"),
              Text(""),
            ],
          ),
        ),
    );
  }
}
